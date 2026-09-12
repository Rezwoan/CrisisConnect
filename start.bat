@echo off
start "CrisisConnect Backend"  cmd /k "cd /d E:\CrisisConnect\CrisisConnect-Backend && npm run start:dev"
start "CrisisConnect Frontend" cmd /k "cd /d E:\CrisisConnect\crisisconnect-frontend && npm run dev"
