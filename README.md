# Decentralized Academic Credential Verification System

A comprehensive blockchain-based system for managing, verifying, and sharing academic credentials using Stacks blockchain and Clarity smart contracts.

## Overview

This system provides five interconnected but independent smart contracts that handle different aspects of academic credential verification:

1. **Degree Authentication Contract** - Creates tamper-proof digital diplomas and certificates
2. **Skill Verification Contract** - Records and verifies professional competencies and achievements
3. **Transcript Portability Contract** - Enables secure transcript sharing between institutions
4. **Continuing Education Tracking Contract** - Maintains lifelong learning and certification records
5. **Employer Verification Contract** - Allows employers to instantly verify candidate credentials

## Key Features

- **Tamper-Proof Records**: All credentials are stored immutably on the blockchain
- **Decentralized Verification**: No single point of failure or control
- **Privacy-Preserving**: Students control access to their credentials
- **Instant Verification**: Employers can verify credentials in real-time
- **Cross-Institution Compatibility**: Standardized format for credential sharing
- **Lifetime Accessibility**: Credentials remain accessible regardless of institutional changes

## Smart Contracts

### 1. Degree Authentication Contract (\`degree-authentication.clar\`)

Manages the issuance and verification of academic degrees and certificates.

**Key Functions:**
- \`issue-degree\`: Issue a new degree credential
- \`verify-degree\`: Verify the authenticity of a degree
- \`revoke-degree\`: Revoke a degree (admin only)
- \`get-degree-details\`: Retrieve degree information

**Data Stored:**
- Degree type and level
- Institution information
- Student details
- Graduation date
- GPA and honors
- Digital signature

### 2. Skill Verification Contract (\`skill-verification.clar\`)

Records and verifies professional competencies and skill achievements.

**Key Functions:**
- \`add-skill\`: Add a verified skill to a student's profile
- \`endorse-skill\`: Allow endorsements from verified sources
- \`verify-skill-level\`: Verify proficiency level in a skill
- \`get-skill-portfolio\`: Retrieve complete skill profile

**Data Stored:**
- Skill categories and levels
- Verification sources
- Endorsement count
- Certification dates
- Evidence links

### 3. Transcript Portability Contract (\`transcript-portability.clar\`)

Enables secure sharing of academic transcripts between institutions.

**Key Functions:**
- \`create-transcript\`: Create a new transcript record
- \`share-transcript\`: Grant access to specific institutions
- \`verify-transcript\`: Verify transcript authenticity
- \`transfer-credits\`: Facilitate credit transfers

**Data Stored:**
- Course records
- Grades and credits
- Institution details
- Transfer history
- Access permissions

### 4. Continuing Education Tracking Contract (\`continuing-education.clar\`)

Maintains records of lifelong learning and professional development.

**Key Functions:**
- \`add-certification\`: Add professional certifications
- \`track-course-completion\`: Record completed courses
- \`verify-continuing-education\`: Verify ongoing education requirements
- \`get-learning-history\`: Retrieve complete learning timeline

**Data Stored:**
- Certification details
- Course completions
- Professional development hours
- Renewal dates
- Industry requirements

### 5. Employer Verification Contract (\`employer-verification.clar\`)

Allows employers to verify candidate credentials efficiently.

**Key Functions:**
- \`request-verification\`: Request credential verification
- \`batch-verify\`: Verify multiple credentials at once
- \`get-verification-report\`: Generate comprehensive verification reports
- \`register-employer\`: Register as a verified employer

**Data Stored:**
- Verification requests
- Employer registrations
- Verification results
- Access logs

## Security Features

- **Multi-signature Requirements**: Critical operations require multiple signatures
- **Role-Based Access Control**: Different permission levels for institutions, students, and employers
- **Audit Trails**: Complete history of all credential operations
- **Privacy Controls**: Students control who can access their credentials
- **Fraud Prevention**: Built-in mechanisms to detect and prevent credential fraud

## Getting Started

### Prerequisites

- Clarinet CLI installed
- Node.js and npm
- Stacks wallet for testing

### Installation

1. Clone the repository
2. Install dependencies: \`npm install\`
3. Run tests: \`npm test\`
4. Deploy contracts: \`clarinet deploy\`

### Usage

1. **For Educational Institutions:**
    - Register as an authorized issuer
    - Issue degrees and certificates
    - Manage transcript records

2. **For Students:**
    - Claim your credentials
    - Control access permissions
    - Share credentials with employers

3. **For Employers:**
    - Register for verification access
    - Verify candidate credentials
    - Generate verification reports

## Testing

The system includes comprehensive tests using Vitest:

\`\`\`bash
npm test
\`\`\`

Tests cover:
- Contract deployment
- Credential issuance and verification
- Access control mechanisms
- Error handling
- Edge cases

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

MIT License - see LICENSE file for details

## Support

For questions or support, please open an issue in the repository.
