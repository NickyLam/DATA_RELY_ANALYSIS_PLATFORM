/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_jdjr_cuscredit_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_jdjr_cuscredit_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_jdjr_cuscredit_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_jdjr_cuscredit_info(
    limitno varchar2(120) -- 客户额度编号
    ,unusedlimitamt number(26,8) -- 未动拨授信额度
    ,creditstatus varchar2(6) -- 授信状态A、有效B、无效
    ,creditstartdt varchar2(20) -- 授信生效起始日期
    ,creditlimitamt number(26,8) -- 授信额度
    ,templimitflag varchar2(8) -- 是否临时额度1、是0、否
    ,prdno varchar2(8) -- 产品编号
    ,bussdate varchar2(20) -- 数据日期
    ,currency varchar2(3) -- 币种
    ,creditenddt varchar2(20) -- 授信到期日
    ,cusno varchar2(120) -- 京东pin
    ,migtflag varchar2(80) -- 
    ,cyclelimitflag varchar2(20) -- 循环额度标志
    ,prdcode varchar2(120) -- 产品编号（行内）
    ,creditdays number(22) -- 授信期限
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
grant select on ${iol_schema}.icms_jdjr_cuscredit_info to ${iml_schema};
grant select on ${iol_schema}.icms_jdjr_cuscredit_info to ${icl_schema};
grant select on ${iol_schema}.icms_jdjr_cuscredit_info to ${idl_schema};
grant select on ${iol_schema}.icms_jdjr_cuscredit_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_jdjr_cuscredit_info is '授信额度信息全量数据';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.limitno is '客户额度编号';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.unusedlimitamt is '未动拨授信额度';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.creditstatus is '授信状态A、有效B、无效';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.creditstartdt is '授信生效起始日期';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.creditlimitamt is '授信额度';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.templimitflag is '是否临时额度1、是0、否';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.prdno is '产品编号';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.bussdate is '数据日期';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.currency is '币种';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.creditenddt is '授信到期日';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.cusno is '京东pin';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.migtflag is '';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.cyclelimitflag is '循环额度标志';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.prdcode is '产品编号（行内）';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.creditdays is '授信期限';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_jdjr_cuscredit_info.etl_timestamp is 'ETL处理时间戳';
