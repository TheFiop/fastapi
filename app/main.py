from fastapi import FastAPI


app = FastAPI(title="Demo CI/CD")

@app.get("/")
def root():
    return {"message": "Hello from CI/CD on EKS!"}


@app.get("/healthz")
def health():
    return {"status": "ok"}