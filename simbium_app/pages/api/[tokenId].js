// Next.js API route support: https://nextjs.org/docs/api-routes/introduction

export default function handler(req, res) {
  const tokenId = req.query.tokenId;
  const image_url = "https://raw.githubusercontent.com/LearnWeb3DAO/NFT-Collection/main/my-app/public/cryptodevs/";
  res.status(200).json({
    name: "Simbium Dev #" + tokenId,
    descrption: "Simbium Dev is a collection of developers in crypto",
    image: image_url + tokenId + ".svg",
  })
}