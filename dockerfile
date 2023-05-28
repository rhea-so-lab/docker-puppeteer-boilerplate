# Builder
FROM node:20.2.0 AS builder
WORKDIR /dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production

# Runner
FROM node:20.2.0-alpine AS runner
WORKDIR /app

ENV HOST docker
RUN apk add --no-cache udev ttf-freefont chromium
RUN mkdir /usr/share/fonts/nanumfont
RUN wget http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFont_TTF_ALL.zip
RUN unzip NanumFont_TTF_ALL.zip -d /usr/share/fonts/nanumfont
RUN fc-cache -f -v
ENV LANG=ko_KR.UTF-8
ENV LANGUAGE=ko_KR.UTF-8
RUN apk add curl
RUN apk add --no-cache tzdata && \
  cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
  echo "Asia/Seoul" > /etc/timezone && \
  apk del tzdata
COPY --from=builder /dependencies ./
COPY src ./src
COPY tsconfig.json ./
RUN yarn build
CMD ["node", "dist/main.js"]