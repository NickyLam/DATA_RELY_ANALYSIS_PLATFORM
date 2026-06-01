/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_asset_transfer_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_asset_transfer_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_asset_transfer_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_asset_transfer_detail(
    termno number(20,0) -- 期次号，从1开始
    ,settledate varchar2(8) -- 业务日期，格式：YYYYMMDD
    ,seqno varchar2(64) -- 资产转让业务流水号
    ,transtime varchar2(32) -- 交易时间，格式：yyyy-MM-ddHH:mm:ss
    ,diffamt number(20,0) -- 作价资产余额和转让金额之间的差价
    ,fundseqno varchar2(64) -- 资金流水号,可以关联网商银行资金对账文件的tdsubdetail字段
    ,prinbal number(20,0) -- 本金余额（单位分）
    ,startdate varchar2(8) -- 分期开始日期，格式：yyyyMMdd
    ,ovdintpnltbal number(20,0) -- 逾期利息罚息余额（单位分），指的是应收未收逾利罚
    ,contractno varchar2(64) -- 平台贷款合同号
    ,ovdprinpnltbal number(20,0) -- 逾期本金罚息余额（单位分），指的是已结的应收未收逾本罚
    ,fvtpltag varchar2(2) -- 平价和折溢价转让为N，净值回购为Y
    ,status varchar2(10) -- 分期状态，正常NORMAL,逾期OVD
    ,bsntype varchar2(20) -- 产品业务类型，具体值合作产品上线后才给出
    ,intbal number(20,0) -- 利息余额（单位分），指的是已结的应收未收利息和未到期的计提利息
    ,opttype varchar2(8) -- 操作类型，转出（OUT）\转入（IN）
    ,writeoff varchar2(2) -- 核销标识，已核销为Y，否则为N
    ,regioncode varchar2(8) -- 行政区划
    ,opstorg varchar2(64) -- 资产转让交易对手机构
    ,enddate varchar2(8) -- 分期结束日期，也是当期的还款日，格式：yyyyMMdd
    ,clearingamt number(20,0) -- 转让金额（单位分）
    ,accruedstatus varchar2(2) -- 应计非应计标识，应计0，非应计1
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_mybk_asset_transfer_detail to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer_detail to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer_detail to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_asset_transfer_detail is '资产转让明细文件';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.termno is '期次号，从1开始';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.settledate is '业务日期，格式：YYYYMMDD';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.seqno is '资产转让业务流水号';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.transtime is '交易时间，格式：yyyy-MM-ddHH:mm:ss';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.diffamt is '作价资产余额和转让金额之间的差价';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.fundseqno is '资金流水号,可以关联网商银行资金对账文件的tdsubdetail字段';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.prinbal is '本金余额（单位分）';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.startdate is '分期开始日期，格式：yyyyMMdd';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.ovdintpnltbal is '逾期利息罚息余额（单位分），指的是应收未收逾利罚';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.contractno is '平台贷款合同号';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.ovdprinpnltbal is '逾期本金罚息余额（单位分），指的是已结的应收未收逾本罚';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.fvtpltag is '平价和折溢价转让为N，净值回购为Y';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.status is '分期状态，正常NORMAL,逾期OVD';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.bsntype is '产品业务类型，具体值合作产品上线后才给出';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.intbal is '利息余额（单位分），指的是已结的应收未收利息和未到期的计提利息';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.opttype is '操作类型，转出（OUT）\转入（IN）';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.writeoff is '核销标识，已核销为Y，否则为N';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.regioncode is '行政区划';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.opstorg is '资产转让交易对手机构';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.enddate is '分期结束日期，也是当期的还款日，格式：yyyyMMdd';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.clearingamt is '转让金额（单位分）';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.accruedstatus is '应计非应计标识，应计0，非应计1';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail.etl_timestamp is 'ETL处理时间戳';
