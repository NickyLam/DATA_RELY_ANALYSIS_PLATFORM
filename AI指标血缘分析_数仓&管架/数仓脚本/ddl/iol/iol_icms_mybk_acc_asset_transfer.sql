/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_acc_asset_transfer
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_acc_asset_transfer
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_acc_asset_transfer purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_acc_asset_transfer(
    termno varchar2(32) -- 期次号，从1开始
    ,settledate varchar2(16) -- 业务日期，格式：YYYYMMDD
    ,seqno varchar2(128) -- 资产转让业务流水号
    ,fundseqno varchar2(128) -- 资金流水号,可以关联网商银行资金对账文件的td_sub_detail字段
    ,enddate varchar2(16) -- 分期结束日期，也是当期的还款日，格式：yyyyMMdd
    ,ovdprinpnltbal number(24,6) -- 逾期本金罚息余额（单位分），指的是已结的应收未收逾本罚
    ,regioncode varchar2(16) -- 行政区划
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,prinbal number(24,6) -- 本金余额（单位分）
    ,accruedstatus varchar2(4) -- 应计非应计标识，应计0，非应计1
    ,ovdintpnltbal number(24,6) -- 逾期利息罚息余额（单位分），指的是应收未收逾利罚
    ,diffamt number(24,6) -- 作价资产余额和转让金额之间的差价
    ,intbal number(24,6) -- 利息余额（单位分），指的是已结的应收未收利息和未到期的计提利息
    ,contractno varchar2(64) -- 平台贷款合同号
    ,status varchar2(20) -- 分期状态，正常NORMAL,逾期OVD
    ,opstorg varchar2(128) -- 资产转让交易对手机构
    ,opttype varchar2(16) -- 操作类型，转出（OUT）\转入（IN）
    ,fvtpltag varchar2(4) -- 平价和折溢价转让为N，净值回购为Y
    ,transtime varchar2(60) -- 交易时间，格式：yyyy-MM-ddHH:mm:ss
    ,startdate varchar2(16) -- 分期开始日期，格式：yyyyMMdd
    ,clearingamt number(24,6) -- 转让金额（单位分）
    ,bsntype varchar2(40) -- 产品业务类型，具体值合作产品上线后才给出
    ,writeoff varchar2(4) -- 核销标识，已核销为Y，否则为N
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
grant select on ${iol_schema}.icms_mybk_acc_asset_transfer to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_acc_asset_transfer to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_acc_asset_transfer to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_acc_asset_transfer to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_acc_asset_transfer is '网商贷资产流转明细';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.termno is '期次号，从1开始';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.settledate is '业务日期，格式：YYYYMMDD';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.seqno is '资产转让业务流水号';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.fundseqno is '资金流水号,可以关联网商银行资金对账文件的td_sub_detail字段';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.enddate is '分期结束日期，也是当期的还款日，格式：yyyyMMdd';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.ovdprinpnltbal is '逾期本金罚息余额（单位分），指的是已结的应收未收逾本罚';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.regioncode is '行政区划';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.prinbal is '本金余额（单位分）';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.accruedstatus is '应计非应计标识，应计0，非应计1';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.ovdintpnltbal is '逾期利息罚息余额（单位分），指的是应收未收逾利罚';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.diffamt is '作价资产余额和转让金额之间的差价';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.intbal is '利息余额（单位分），指的是已结的应收未收利息和未到期的计提利息';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.contractno is '平台贷款合同号';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.status is '分期状态，正常NORMAL,逾期OVD';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.opstorg is '资产转让交易对手机构';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.opttype is '操作类型，转出（OUT）\转入（IN）';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.fvtpltag is '平价和折溢价转让为N，净值回购为Y';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.transtime is '交易时间，格式：yyyy-MM-ddHH:mm:ss';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.startdate is '分期开始日期，格式：yyyyMMdd';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.clearingamt is '转让金额（单位分）';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.bsntype is '产品业务类型，具体值合作产品上线后才给出';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.writeoff is '核销标识，已核销为Y，否则为N';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_mybk_acc_asset_transfer.etl_timestamp is 'ETL处理时间戳';
