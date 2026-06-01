/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_pph_claim_appl_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_pph_claim_appl_data
whenever sqlerror continue none;
drop table ${iol_schema}.icms_pph_claim_appl_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_pph_claim_appl_data(
    loanno varchar2(32) -- 借据号
    ,capdays number(10,0) -- 逾期总天数
    ,capital number(15,2) -- 逾期总本金
    ,aint number(15,2) -- 逾期利息
    ,oint number(15,2) -- 逾期罚息
    ,nint number(15,2) -- 未计利息
    ,curnint number(15,2) -- 未到期本金
    ,claimamt number(15,2) -- 理赔总金额
    ,claimmsg varchar2(1200) -- 理赔申请书信息
    ,inputdate varchar2(10) -- 录入日期
    ,compid varchar2(10) -- 助贷公司编码
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_pph_claim_appl_data to ${iml_schema};
grant select on ${iol_schema}.icms_pph_claim_appl_data to ${icl_schema};
grant select on ${iol_schema}.icms_pph_claim_appl_data to ${idl_schema};
grant select on ${iol_schema}.icms_pph_claim_appl_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_pph_claim_appl_data is '信贷系统普惠理赔申请';
comment on column ${iol_schema}.icms_pph_claim_appl_data.loanno is '借据号';
comment on column ${iol_schema}.icms_pph_claim_appl_data.capdays is '逾期总天数';
comment on column ${iol_schema}.icms_pph_claim_appl_data.capital is '逾期总本金';
comment on column ${iol_schema}.icms_pph_claim_appl_data.aint is '逾期利息';
comment on column ${iol_schema}.icms_pph_claim_appl_data.oint is '逾期罚息';
comment on column ${iol_schema}.icms_pph_claim_appl_data.nint is '未计利息';
comment on column ${iol_schema}.icms_pph_claim_appl_data.curnint is '未到期本金';
comment on column ${iol_schema}.icms_pph_claim_appl_data.claimamt is '理赔总金额';
comment on column ${iol_schema}.icms_pph_claim_appl_data.claimmsg is '理赔申请书信息';
comment on column ${iol_schema}.icms_pph_claim_appl_data.inputdate is '录入日期';
comment on column ${iol_schema}.icms_pph_claim_appl_data.compid is '助贷公司编码';
comment on column ${iol_schema}.icms_pph_claim_appl_data.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_pph_claim_appl_data.start_dt is '开始时间';
comment on column ${iol_schema}.icms_pph_claim_appl_data.end_dt is '结束时间';
comment on column ${iol_schema}.icms_pph_claim_appl_data.id_mark is '增删标志';
comment on column ${iol_schema}.icms_pph_claim_appl_data.etl_timestamp is 'ETL处理时间戳';
