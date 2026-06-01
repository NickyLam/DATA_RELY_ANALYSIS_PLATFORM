/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_standardloancard
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_standardloancard
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_standardloancard purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_standardloancard(
    id varchar2(96) -- 代码主键
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号
    ,msgidno varchar2(53) -- 报文标识号
    ,crnotclsgllpsninstnum number(22) -- 征信未结清贷款法人机构数:pc02is01
    ,acc_num number(22) -- 账户数量:pc02is02
    ,crnotcnclactqcccgtamt number(38,0) -- 征信未销户准贷记卡授信总额:pc02ij01
    ,hgamt number(38,0) -- 最高金额:pc02ij02
    ,lwst_amt number(38,0) -- 最低金额:pc02ij03
    ,cr_qcrcrd_od_bal number(38,0) -- 征信准贷记卡透支余额:pc02ij04
    ,crqcrcrdry6moavgodbal number(38,0) -- 征信准贷记卡最近6月平均透支余额:pc02ij05
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,crt_dt_tm date -- 创建日期时间
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
grant select on ${iol_schema}.cqss_i_r_standardloancard to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_standardloancard to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_standardloancard to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_standardloancard to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_standardloancard is '二代准贷记卡账户信息';
comment on column ${iol_schema}.cqss_i_r_standardloancard.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_standardloancard.cr_supr_rcrd_id is '征信上级记录编号';
comment on column ${iol_schema}.cqss_i_r_standardloancard.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_standardloancard.crnotclsgllpsninstnum is '征信未结清贷款法人机构数:pc02is01';
comment on column ${iol_schema}.cqss_i_r_standardloancard.acc_num is '账户数量:pc02is02';
comment on column ${iol_schema}.cqss_i_r_standardloancard.crnotcnclactqcccgtamt is '征信未销户准贷记卡授信总额:pc02ij01';
comment on column ${iol_schema}.cqss_i_r_standardloancard.hgamt is '最高金额:pc02ij02';
comment on column ${iol_schema}.cqss_i_r_standardloancard.lwst_amt is '最低金额:pc02ij03';
comment on column ${iol_schema}.cqss_i_r_standardloancard.cr_qcrcrd_od_bal is '征信准贷记卡透支余额:pc02ij04';
comment on column ${iol_schema}.cqss_i_r_standardloancard.crqcrcrdry6moavgodbal is '征信准贷记卡最近6月平均透支余额:pc02ij05';
comment on column ${iol_schema}.cqss_i_r_standardloancard.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_standardloancard.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_standardloancard.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_standardloancard.etl_timestamp is 'ETL处理时间戳';
