/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_jdjr_quotaadjust_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_jdjr_quotaadjust_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_jdjr_quotaadjust_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_jdjr_quotaadjust_info(
    adjustlimitno varchar2(120) -- 调额流水号
    ,prdcode varchar2(120) -- 产品编号（行内）
    ,afteradjustlimit number(26,8) -- 调额后授信额度
    ,prdno varchar2(8) -- 产品编号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,limitno varchar2(120) -- 客户额度编号
    ,adjusttype varchar2(4) -- 调额方式
    ,adjustlimit number(26,8) -- 调额额度
    ,beforeadjustlimit number(26,8) -- 调额前授信额度
    ,bussdate varchar2(20) -- 数据日期
    ,adjuststartdt varchar2(20) -- 调额额度生成日（客户接受/系统生效的日期）
    ,limitupdown varchar2(4) -- 调额类型
    ,cusno varchar2(120) -- 京东pin
    ,adjustdt varchar2(20) -- 调额额度生成日（系统计算调额的日期）
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
grant select on ${iol_schema}.icms_jdjr_quotaadjust_info to ${iml_schema};
grant select on ${iol_schema}.icms_jdjr_quotaadjust_info to ${icl_schema};
grant select on ${iol_schema}.icms_jdjr_quotaadjust_info to ${idl_schema};
grant select on ${iol_schema}.icms_jdjr_quotaadjust_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_jdjr_quotaadjust_info is '调额信息全量数据';
comment on column ${iol_schema}.icms_jdjr_quotaadjust_info.adjustlimitno is '调额流水号';
comment on column ${iol_schema}.icms_jdjr_quotaadjust_info.prdcode is '产品编号（行内）';
comment on column ${iol_schema}.icms_jdjr_quotaadjust_info.afteradjustlimit is '调额后授信额度';
comment on column ${iol_schema}.icms_jdjr_quotaadjust_info.prdno is '产品编号';
comment on column ${iol_schema}.icms_jdjr_quotaadjust_info.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_jdjr_quotaadjust_info.limitno is '客户额度编号';
comment on column ${iol_schema}.icms_jdjr_quotaadjust_info.adjusttype is '调额方式';
comment on column ${iol_schema}.icms_jdjr_quotaadjust_info.adjustlimit is '调额额度';
comment on column ${iol_schema}.icms_jdjr_quotaadjust_info.beforeadjustlimit is '调额前授信额度';
comment on column ${iol_schema}.icms_jdjr_quotaadjust_info.bussdate is '数据日期';
comment on column ${iol_schema}.icms_jdjr_quotaadjust_info.adjuststartdt is '调额额度生成日（客户接受/系统生效的日期）';
comment on column ${iol_schema}.icms_jdjr_quotaadjust_info.limitupdown is '调额类型';
comment on column ${iol_schema}.icms_jdjr_quotaadjust_info.cusno is '京东pin';
comment on column ${iol_schema}.icms_jdjr_quotaadjust_info.adjustdt is '调额额度生成日（系统计算调额的日期）';
comment on column ${iol_schema}.icms_jdjr_quotaadjust_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_jdjr_quotaadjust_info.etl_timestamp is 'ETL处理时间戳';
