/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_repaydutyinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_repaydutyinfo
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_repaydutyinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_repaydutyinfo(
    id varchar2(96) -- 代码主键
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号
    ,msgidno varchar2(53) -- 报文标识号
    ,idnt_inf_cgycd varchar2(2) -- 身份信息类别代码:pc02kd01
    ,rel_repy_rspl_tp varchar2(9) -- 相关还款责任类型:pc02kd02
    ,acc_num number(22) -- 账户数量:pc02ks02
    ,grnt_ctr_id varchar2(90) -- 保证合同编号
    ,repy_rspl_qot number(38,0) -- 还款责任金额:pc02kj01
    ,tot_acba number(38,0) -- 总账户余额:pc02kj02
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
grant select on ${iol_schema}.cqss_i_r_repaydutyinfo to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_repaydutyinfo to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_repaydutyinfo to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_repaydutyinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_repaydutyinfo is '二代相关还款责任汇总信息';
comment on column ${iol_schema}.cqss_i_r_repaydutyinfo.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_repaydutyinfo.cr_supr_rcrd_id is '征信上级记录编号';
comment on column ${iol_schema}.cqss_i_r_repaydutyinfo.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_repaydutyinfo.idnt_inf_cgycd is '身份信息类别代码:pc02kd01';
comment on column ${iol_schema}.cqss_i_r_repaydutyinfo.rel_repy_rspl_tp is '相关还款责任类型:pc02kd02';
comment on column ${iol_schema}.cqss_i_r_repaydutyinfo.acc_num is '账户数量:pc02ks02';
comment on column ${iol_schema}.cqss_i_r_repaydutyinfo.grnt_ctr_id is '保证合同编号';
comment on column ${iol_schema}.cqss_i_r_repaydutyinfo.repy_rspl_qot is '还款责任金额:pc02kj01';
comment on column ${iol_schema}.cqss_i_r_repaydutyinfo.tot_acba is '总账户余额:pc02kj02';
comment on column ${iol_schema}.cqss_i_r_repaydutyinfo.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_repaydutyinfo.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_repaydutyinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_repaydutyinfo.etl_timestamp is 'ETL处理时间戳';
