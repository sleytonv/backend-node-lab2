import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { Logger } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const port = Number(process.env.PORT ?? 4000);
  const host = process.env.HOST ?? '0.0.0.0'; // <-- clave
  await app.listen(port, host);
  console.log(`[bootstrap] Listening on http://${host}:${port}`);
}
bootstrap().catch((e) => console.log(`Error al iniciar la aplicacion: ${e}`));
