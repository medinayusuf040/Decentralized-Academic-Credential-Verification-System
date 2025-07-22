;; Continuing Education Tracking Contract
;; Maintains lifelong learning and certification records

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u400))
(define-constant ERR-CERTIFICATION-NOT-FOUND (err u401))
(define-constant ERR-CERTIFICATION-ALREADY-EXISTS (err u402))
(define-constant ERR-INVALID-INPUT (err u403))
(define-constant ERR-CERTIFICATION-EXPIRED (err u404))

;; Data Variables
(define-data-var next-certification-id uint u1)

;; Data Maps
(define-map authorized-providers principal bool)
(define-map certifications uint {
    holder: principal,
    provider: principal,
    certification-name: (string-ascii 100),
    certification-type: (string-ascii 50),
    issue-date: uint,
    expiry-date: (optional uint),
    renewal-required: bool,
    hours-completed: uint,
    certification-hash: (buff 32),
    is-active: bool
})

(define-map continuing-education-records uint {
    certification-id: uint,
    activity-type: (string-ascii 50),
    activity-name: (string-ascii 100),
    completion-date: uint,
    hours-earned: uint,
    provider: principal,
    evidence-hash: (optional (buff 32))
})

(define-map user-certifications principal (list 30 uint))
(define-map provider-certifications principal (list 1000 uint))
(define-map certification-activities uint (list 50 uint))
(define-data-var next-activity-id uint u1)

;; Authorization Functions
(define-public (authorize-provider (provider principal))
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (ok (map-set authorized-providers provider true))
    )
)

(define-public (revoke-provider (provider principal))
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (ok (map-delete authorized-providers provider))
    )
)

;; Core Functions
(define-public (add-certification
    (holder principal)
    (certification-name (string-ascii 100))
    (certification-type (string-ascii 50))
    (issue-date uint)
    (expiry-date (optional uint))
    (renewal-required bool)
    (hours-completed uint)
    (certification-hash (buff 32)))
    (let (
        (certification-id (var-get next-certification-id))
        (current-user-certifications (default-to (list) (map-get? user-certifications holder)))
        (current-provider-certifications (default-to (list) (map-get? provider-certifications tx-sender)))
    )
        (asserts! (default-to false (map-get? authorized-providers tx-sender)) ERR-NOT-AUTHORIZED)
        (asserts! (> (len certification-name) u0) ERR-INVALID-INPUT)
        (asserts! (> (len certification-type) u0) ERR-INVALID-INPUT)
        (asserts! (> issue-date u0) ERR-INVALID-INPUT)
        (asserts! (> hours-completed u0) ERR-INVALID-INPUT)

        (map-set certifications certification-id {
            holder: holder,
            provider: tx-sender,
            certification-name: certification-name,
            certification-type: certification-type,
            issue-date: issue-date,
            expiry-date: expiry-date,
            renewal-required: renewal-required,
            hours-completed: hours-completed,
            certification-hash: certification-hash,
            is-active: true
        })

        (map-set user-certifications holder (unwrap! (as-max-len? (append current-user-certifications certification-id) u30) ERR-INVALID-INPUT))
        (map-set provider-certifications tx-sender (unwrap! (as-max-len? (append current-provider-certifications certification-id) u1000) ERR-INVALID-INPUT))

        (var-set next-certification-id (+ certification-id u1))
        (ok certification-id)
    )
)

(define-public (track-course-completion
    (certification-id uint)
    (activity-type (string-ascii 50))
    (activity-name (string-ascii 100))
    (completion-date uint)
    (hours-earned uint)
    (evidence-hash (optional (buff 32))))
    (let (
        (activity-id (var-get next-activity-id))
        (certification-data (unwrap! (map-get? certifications certification-id) ERR-CERTIFICATION-NOT-FOUND))
        (current-activities (default-to (list) (map-get? certification-activities certification-id)))
    )
        (asserts! (default-to false (map-get? authorized-providers tx-sender)) ERR-NOT-AUTHORIZED)
        (asserts! (get is-active certification-data) ERR-CERTIFICATION-NOT-FOUND)
        (asserts! (> (len activity-type) u0) ERR-INVALID-INPUT)
        (asserts! (> (len activity-name) u0) ERR-INVALID-INPUT)
        (asserts! (> completion-date u0) ERR-INVALID-INPUT)
        (asserts! (> hours-earned u0) ERR-INVALID-INPUT)

        (map-set continuing-education-records activity-id {
            certification-id: certification-id,
            activity-type: activity-type,
            activity-name: activity-name,
            completion-date: completion-date,
            hours-earned: hours-earned,
            provider: tx-sender,
            evidence-hash: evidence-hash
        })

        (map-set certification-activities certification-id (unwrap! (as-max-len? (append current-activities activity-id) u50) ERR-INVALID-INPUT))

        (var-set next-activity-id (+ activity-id u1))
        (ok activity-id)
    )
)

(define-public (renew-certification (certification-id uint) (new-expiry-date uint))
    (let (
        (certification-data (unwrap! (map-get? certifications certification-id) ERR-CERTIFICATION-NOT-FOUND))
    )
        (asserts! (is-eq tx-sender (get provider certification-data)) ERR-NOT-AUTHORIZED)
        (asserts! (get is-active certification-data) ERR-CERTIFICATION-NOT-FOUND)
        (asserts! (> new-expiry-date block-height) ERR-INVALID-INPUT)

        (ok (map-set certifications certification-id (merge certification-data {
            expiry-date: (some new-expiry-date)
        })))
    )
)

(define-public (deactivate-certification (certification-id uint))
    (let (
        (certification-data (unwrap! (map-get? certifications certification-id) ERR-CERTIFICATION-NOT-FOUND))
    )
        (asserts! (or (is-eq tx-sender (get holder certification-data))
                     (is-eq tx-sender (get provider certification-data))) ERR-NOT-AUTHORIZED)
        (asserts! (get is-active certification-data) ERR-CERTIFICATION-NOT-FOUND)

        (ok (map-set certifications certification-id (merge certification-data { is-active: false })))
    )
)

;; Read-only Functions
(define-read-only (verify-continuing-education (certification-id uint))
    (match (map-get? certifications certification-id)
        certification-data (ok {
            is-valid: (and (get is-active certification-data)
                          (match (get expiry-date certification-data)
                              expiry (>= expiry block-height)
                              true)),
            holder: (get holder certification-data),
            certification-name: (get certification-name certification-data),
            certification-type: (get certification-type certification-data),
            provider: (get provider certification-data),
            hours-completed: (get hours-completed certification-data),
            renewal-required: (get renewal-required certification-data)
        })
        ERR-CERTIFICATION-NOT-FOUND
    )
)

(define-read-only (get-certification-details (certification-id uint))
    (map-get? certifications certification-id)
)

(define-read-only (get-learning-history (holder principal))
    (map-get? user-certifications holder)
)

(define-read-only (get-certification-activities (certification-id uint))
    (map-get? certification-activities certification-id)
)

(define-read-only (get-activity-details (activity-id uint))
    (map-get? continuing-education-records activity-id)
)

(define-read-only (is-authorized-provider (provider principal))
    (default-to false (map-get? authorized-providers provider))
)

(define-read-only (get-provider-certifications (provider principal))
    (map-get? provider-certifications provider)
)

(define-read-only (calculate-total-hours (certification-id uint))
    (let (
        (activities (default-to (list) (map-get? certification-activities certification-id)))
    )
        (ok (fold + (map get-activity-hours activities) u0))
    )
)

(define-private (get-activity-hours (activity-id uint))
    (match (map-get? continuing-education-records activity-id)
        activity-data (get hours-earned activity-data)
        u0
    )
)
