# PGR301 Eksamen 2025 - Besvarelse

**Kandidatnummer:** [FYLL INN DITT KANDIDATNUMMER]

**Repository:** [URL til ditt GitHub repository]

---

## Oppgave 1 - Terraform, S3 og Infrastruktur som Kode (15 poeng)

### Leveranser

#### Terraform-kode
- **Mappe:** `infra-s3/`
- **Filer:**
  - `main.tf` - Hovedkonfigurasjon med S3 bucket og lifecycle policies
  - `variables.tf` - Variable definisjoner med validering
  - `outputs.tf` - Output verdier
  - `README.md` - Dokumentasjon

#### GitHub Actions Workflow
- **Workflow-fil:** `.github/workflows/terraform-s3.yml`
- **Funksjonalitet:**
  - Kjører `terraform fmt -check`, `validate` og `plan` på pull requests
  - Kjører `terraform apply` ved push til main branch
  - Path filtering: kjører kun ved endringer i `infra-s3/` eller workflow-fil

#### S3 Bucket og Lifecycle Policy
- **Bucket navn:** `kandidat-[XXX]-data` (erstatt [XXX] med ditt kandidatnummer)
- **Region:** eu-west-1
- **Lifecycle policy:**
  - Filer under `midlertidig/` prefix flyttes til Glacier etter 30 dager
  - Filer under `midlertidig/` slettes etter 90 dager
  - Filer utenfor `midlertidig/` påvirkes ikke

#### Instruksjoner for sensor

For å kjøre Terraform-koden i din egen fork:

1. **Konfigurer AWS credentials som GitHub Secrets:**
   - Gå til Settings → Secrets and variables → Actions
   - Legg til `AWS_ACCESS_KEY_ID`
   - Legg til `AWS_SECRET_ACCESS_KEY`

2. **Opprett terraform.tfvars fil:**
   ```bash
   cd infra-s3
   cp terraform.tfvars.example terraform.tfvars
   ```
   
3. **Rediger terraform.tfvars og erstatt XXX med ditt kandidatnummer:**
   ```hcl
   bucket_name = "kandidat-123-data"  # Bytt 123 med ditt nummer
   ```

4. **Kjør Terraform lokalt (eller push til main for automatisk deploy):**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

---

## Oppgave 2 - AWS Lambda, SAM og GitHub Actions (25 poeng)

### Del A: Deploy og test SAM-applikasjonen (10p)

#### Leveranser

- **API Gateway URL:** [FYLL INN URL HER ETTER DEPLOY]
- **S3 objekt eksempel:** `s3://kandidat-[XXX]-data/midlertidig/comprehend-20250120-120000-abc123.json`
- **Test kommando brukt:**
  ```bash
  curl -X POST https://[YOUR-API-URL]/analyze \
    -H "Content-Type: application/json" \
    -d '{"text": "Apple launches groundbreaking new AI features while Microsoft faces security concerns."}'
  ```

### Del B: Fiks GitHub Actions Workflow (15p)

#### Leveranser

- **Workflow-fil:** `.github/workflows/sam-deploy.yml`
- **Successful deploy:** [LENKE TIL VELLYKKET WORKFLOW-KJØRING]
- **PR validation:** [LENKE TIL PR MED KUN VALIDERING]

#### Instruksjoner til sensor

For å få workflow til å kjøre i din fork:

1. **Konfigurer GitHub Secrets:**
   - Gå til Settings → Secrets and variables → Actions
   - Legg til `AWS_ACCESS_KEY_ID`
   - Legg til `AWS_SECRET_ACCESS_KEY`

2. **Oppdater kandidatnummer i workflow:**
   - Åpne `.github/workflows/sam-deploy.yml`
   - Søk etter steder med kandidatnummer og erstatt med ditt eget

3. **Oppdater S3 bucket navn i SAM template:**
   - Åpne `sam-comprehend/template.yaml`
   - Oppdater `S3BucketName` parameter til `kandidat-[DITT-NR]-data`

4. **Test workflow:**
   - Opprett en ny branch og gjør en endring i `sam-comprehend/`
   - Opprett en pull request - workflow skal kjøre validering uten deploy
   - Merge til main - workflow skal kjøre full deploy

---

## Oppgave 3 - Container og Docker (25 poeng)

### Del A: Containeriser Spring Boot-applikasjonen (10p)

#### Leveranser

- **Dockerfile:** `sentiment-docker/Dockerfile`
- **Multi-stage build:** Ja, bruker Maven for bygg og Corretto Alpine for runtime
- **Test kommando:**
  ```bash
  docker build -t sentiment-docker .
  docker run -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -e S3_BUCKET_NAME=kandidat-[XXX]-data \
    -p 8080:8080 sentiment-docker
  ```

### Del B: GitHub Actions workflow for Docker Hub (15p)

#### Leveranser

- **Workflow-fil:** `.github/workflows/docker-build.yml`
- **Successful build:** [LENKE TIL VELLYKKET WORKFLOW-KJØRING]
- **Container image navn:** `[DOCKER-USERNAME]/sentiment-docker:latest`

#### Tagging-strategi

[FORKLAR DIN VALGTE TAGGING-STRATEGI HER]

Eksempel:
```
Jeg har valgt å bruke flere tags:
- latest: Peker alltid til nyeste build fra main
- sha-<commit>: Knyttet til spesifikk commit for sporbarhet
- v1.0.0: Semantisk versjonering for releases

Dette gir både stabilitet (versjonsnummer) og fleksibilitet (latest for utvikling).
```

#### Beskrivelse for sensor

For å få workflow til å fungere i din fork:

1. **Opprett Docker Hub konto:**
   - Gå til https://hub.docker.com/
   - Registrer deg (gratis)

2. **Opprett Docker Hub token:**
   - Logg inn på Docker Hub
   - Gå til Account Settings → Security → New Access Token
   - Gi token navn: "GitHub Actions"
   - Kopier token (vises kun én gang!)

3. **Konfigurer GitHub Secrets:**
   - Gå til Settings → Secrets and variables → Actions
   - Legg til `DOCKER_USERNAME` (ditt Docker Hub brukernavn)
   - Legg til `DOCKER_TOKEN` (token fra steg 2)

4. **Oppdater workflow med ditt brukernavn:**
   - Åpne `.github/workflows/docker-build.yml`
   - Erstatt eventuelle hardkodede brukernavn med ditt eget

5. **Test workflow:**
   - Gjør en endring i `sentiment-docker/` mappen
   - Push til main branch
   - Workflow skal bygge og pushe til Docker Hub

---

## Oppgave 4 - Observabilitet, Metrikksamling og Overvåkningsinfrastruktur (25 poeng)

### Del A: Implementasjon av Custom Metrics (15p)

#### Leveranser

- **Screenshot:** [LEGG INN SCREENSHOT AV CLOUDWATCH METRICS]
- **Implementerte metrikker:**

1. **[METRIKK 1 NAVN]**
   - Type: [Counter/Timer/Gauge/DistributionSummary]
   - Formål: [FORKLAR HVA DEN MÅLER]
   - Begrunnelse: [HVORFOR DENNE TYPEN ER EGNET]

2. **[METRIKK 2 NAVN]**
   - Type: [Counter/Timer/Gauge/DistributionSummary]
   - Formål: [FORKLAR HVA DEN MÅLER]
   - Begrunnelse: [HVORFOR DENNE TYPEN ER EGNET]

#### Teknisk forklaring

[BESKRIV DESIGNVALGENE DINE OG FORKLAR HVORFOR DU VALGTE SPESIFIKKE INSTRUMENTTYPER]

### Del B: Infrastruktur for Visualisering og Alarmering (10p)

#### Leveranser

- **Terraform-kode:** `infra-cloudwatch/` mappen
- **Dashboard Screenshot:** [LEGG INN SCREENSHOT AV CLOUDWATCH DASHBOARD]
- **Alarm Screenshot:** [LEGG INN SCREENSHOT AV TRIGGERED ALARM]
- **E-post Screenshot:** [LEGG INN SCREENSHOT AV SNS E-POST]

#### Alarm konfigurasjon

- **Metrikk overvåket:** [NAVN PÅ METRIKK]
- **Terskelverdi:** [VERDI]
- **Begrunnelse:** [HVORFOR DENNE VERDIEN ER VALGT]

---

## Oppgave 5 - KI-assistert Systemutvikling og DevOps-prinsipper (10 poeng)

### Drøfting: AI-assistert utvikling og DevOps-prinsipper

#### Innledning

KI-assistert programvareutvikling har raskt blitt allemanns eie. Verktøy som GitHub Copilot, ChatGPT og Claude har endret hvordan utviklere arbeider, og påvirker alle aspekter av DevOps-praksisen. Denne drøftingen vurderer hvordan KI-teknologi påvirker de tre grunnleggende DevOps-prinsippene: Flyt, Feedback og Kontinuerlig læring.

#### 1. Flyt (Flow)

KI-assistenter kan dramatisk akselerere utviklingsflyten ved å automatisere repetitive oppgaver. Boilerplate-kode, konfigurasjoner og testscenarier genereres på sekunder. Dette reduserer time-to-market og fjerner flaskehalser knyttet til manuelle kodingsoppgaver. For infrastruktur som kode kan KI foreslå komplette Terraform-konfigurasjoner eller GitHub Actions workflows, som ellers ville krevd betydelig researchtid.

Men denne effektivitetsgevinsten kommer med utfordringer. KI-generert kode introduserer nye flaskehalser i code review-prosessen. Reviewere må nå validere ikke bare logikk og arkitektur, men også verifisere at AI-forslag følger beste praksis og ikke inneholder subtile sikkerhetssårbarheter. En utvikler som ukritisk aksepterer AI-forslag kan raskt produsere mye kode med lav kvalitet, noe som skaper teknisk gjeld som forsinker senere iterasjoner.

Videre kan overdreven avhengighet av KI føre til at utviklere mister oversikt over arkitektoniske avhengigheter. Når AI genererer integrasjonskode mot eksterne tjenester, kan utvikleren gå glipp av viktige designbeslutninger som påvirker skalerbarhet og vedlikeholdbarhet. I DevOps-kontekst er dette særlig kritisk, da infrastrukturvalg har langsiktige konsekvenser.

#### 2. Feedback

Feedback-loops er kjernen i DevOps - rask tilbakemelding på kodeendringer, automatiserte tester, kontinuerlig overvåking og metrikker. KI kan potensielt forsterke disse loops ved å generere omfattende testsuiter automatisk, noe som gir raskere validering av endringer. AI-verktøy kan også analysere logger og metrikker for å identifisere patterns mennesker overser.

Men kvaliteten på AI-genererte tester er variabel. Tester kan dekke happy path-scenarier, men overse edge cases og feilhåndtering. Dette skaper falsk trygghet: grønne tester betyr ikke nødvendigvis god kvalitet. I en DevOps-pipeline hvor automatiserte tester er gate-keepers for produksjonsdeploy, kan dårlige tester føre til at kritiske feil slipper gjennom.

KI-generert kode krever også nye typer kvalitetssikring. Statiske analyseverktøy og sikkerhetsskanning må utvides for å fange AI-spesifikke antipatterns. Feedback-loops må derfor forlenges for å inkludere grundigere validering, noe som potensielt motvirker hastighetsfordelene KI skulle gi.

Et annet aspekt er at KI-verktøy lærer av eksisterende kodebase. I et prosjekt med teknisk gjeld vil AI reprodusere dårlige mønstre, noe som skaper en negativ feedback-loop hvor suboptimal kode genererer mer suboptimal kode.

#### 3. Kontinuerlig læring og forbedring

DevOps-kultur bygger på kontinuerlig læring - både fra feil og fra hverandre. KI-assistanse har paradoksale effekter her. På den ene siden senker KI inngangsbarrieren: juniorutviklere får tilgang til ekspertise gjennom AI-forslag og kan raskere bli produktive i nye teknologier. Dette demokratiserer kunnskap og akselererer kompetanseutvikling.

På den andre siden kan over-reliance på KI føre til overfladisk forståelse. En utvikler som får løst problemer via AI uten å forstå underliggende prinsipper, utvikler ikke dybdekompetanse. Dette blir kritisk når systemer feiler i produksjon: feilsøking krever fundamental forståelse som AI-assistert utvikling kan ha hindret.

Kunnskapsdeling i team påvirkes også. I tradisjonell DevOps-praksis dokumenteres designbeslutninger, arkitekturvurderinger og tekniske avveininger gjennom code reviews og teknisk dokumentasjon. Når AI genererer kode, kan disse diskusjonene utebli, og implisitt kunnskap går tapt. Dette svekker teamets kollektive læring.

Samtidig åpner KI for nye læringsmuligheter. Utviklere kan eksperimentere med ukjente teknologier uten stor tidsbruk, og AI kan forklare kompleks kode på forståelig måte. Utfordringen ligger i å balansere effektivitet med dybdeforståelse.

#### Konklusjon

KI-assistert utvikling representerer både betydelige muligheter og reelle risikoer for DevOps-praksis. Flyt kan akselereres, men må balanseres med grundig kvalitetssikring. Feedback-loops må utvides for å håndtere AI-spesifikke utfordringer. Kontinuerlig læring krever bevisst innsats for å opprettholde dybdekompetanse.

Suksessfull integrering av KI i DevOps krever at team ser KI som et verktøy for å forsterke, ikke erstatte, profesjonell dømmekraft. Code reviews må være mer grundige, dokumentasjon mer bevisst, og læring mer strukturert. KI bør brukes til å automatisere det banale slik at mennesker kan fokusere på det komplekse: arkitektur, sikkerhet, og brukeropplevelse. Kun da realiserer vi KIs potensial uten å undergrave de prinsippene som gjør DevOps effektivt.

---

## Generelle merknader

[LEGG TIL EVENTUELLE UTFORDRINGER, REFLEKSJONER ELLER KOMMENTARER HER]

---

**Siste oppdatering:** [DATO]
