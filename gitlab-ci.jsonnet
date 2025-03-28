local job(thing) =
  {
    image: "quay.io/skopeo/stable:latest",
    stage: "deploy",
    before_script: [
        "skopeo login harbor.fandrade.com.br -u $HARBOR_USER -p $HARBOR_PASS",
        "skopeo login container.repo.cloudera.com -u $CLOUDERA_USER -p $CLOUDERA_PASS",
    ],
    script: [
        "skopeo copy --all docker://container.repo.cloudera.com/" + thing + " docker://harbor.fandrade.com.br/" + thing,
    ],
    after_script: [
        "skopeo logout harbor.fandrade.com.br",
        "skopeo logout container.repo.cloudera.com",
    ]
  };

local things = [
    'cloudera/admissiond:2024.0.18.4-15', 
    'cloudera/catalogd:2024.0.18.4-15'
];
{
  ['job/' + x]: job(x)
  for x in things
}
