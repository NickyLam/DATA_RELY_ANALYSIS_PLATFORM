/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_asset_transfer_detail_eso
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_asset_transfer_detail_eso
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_asset_transfer_detail_eso purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_asset_transfer_detail_eso(
    contractno varchar2(64) -- 平台贷款合同号
    ,termno number(24,6) -- 期次号
    ,settledate varchar2(8) -- 业务日期
    ,transtime varchar2(64) -- 交易时间
    ,seqno varchar2(64) -- 资产转让业务流水号
    ,fundseqno varchar2(64) -- 资金流水号
    ,startdate varchar2(8) -- 分期开始日期
    ,enddate varchar2(8) -- 分期结束日期
    ,prinbal number(24,6) -- 本金余额（单位分）
    ,intbal number(24,6) -- 利息余额（单位分）
    ,ovdprinpnltbal number(24,6) -- 逾期本金罚息余额（单位分）
    ,ovdintpnltbal number(24,6) -- 逾期利息罚息余额（单位分）
    ,opttype varchar2(8) -- 操作类型
    ,fvtpltag varchar2(2) -- 平价和折溢价转让为N，净值回购为Y
    ,clearingamt number(24,6) -- 转让金额（单位分）
    ,diffamt number(24,6) -- 作价资产余额和转让金额之间的差价
    ,status varchar2(10) -- 分期状态
    ,accruedstatus varchar2(2) -- 应计非应计标识
    ,writeoff varchar2(2) -- 核销标识
    ,opstorg varchar2(64) -- 资产转让交易对手机构
    ,bsntype varchar2(64) -- 产品业务类型
    ,regioncode varchar2(8) -- 行政区划
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
grant select on ${iol_schema}.icms_mybk_asset_transfer_detail_eso to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer_detail_eso to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer_detail_eso to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer_detail_eso to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_asset_transfer_detail_eso is '网商贷资产转让明细文件中间表-债权直转';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.contractno is '平台贷款合同号';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.termno is '期次号';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.settledate is '业务日期';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.transtime is '交易时间';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.seqno is '资产转让业务流水号';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.fundseqno is '资金流水号';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.startdate is '分期开始日期';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.enddate is '分期结束日期';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.prinbal is '本金余额（单位分）';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.intbal is '利息余额（单位分）';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.ovdprinpnltbal is '逾期本金罚息余额（单位分）';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.ovdintpnltbal is '逾期利息罚息余额（单位分）';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.opttype is '操作类型';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.fvtpltag is '平价和折溢价转让为N，净值回购为Y';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.clearingamt is '转让金额（单位分）';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.diffamt is '作价资产余额和转让金额之间的差价';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.status is '分期状态';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.accruedstatus is '应计非应计标识';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.writeoff is '核销标识';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.opstorg is '资产转让交易对手机构';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.bsntype is '产品业务类型';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.regioncode is '行政区划';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_mybk_asset_transfer_detail_eso.etl_timestamp is 'ETL处理时间戳';
