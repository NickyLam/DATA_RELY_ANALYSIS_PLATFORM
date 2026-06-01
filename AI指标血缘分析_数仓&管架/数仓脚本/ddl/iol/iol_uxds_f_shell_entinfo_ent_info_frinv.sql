/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_entinfo_ent_info_frinv
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,currency varchar2(4000) -- 认缴出资币种代码
    ,entstatus varchar2(4000) -- 企业状态
    ,regcap varchar2(4000) -- 注册资本（企业:万元
    ,subconam varchar2(4000) -- 认缴出资额（万元）
    ,regcapcur varchar2(4000) -- 注册资本币种
    ,creditcode varchar2(4000) -- 统一社会信用代码
    ,fundedratio varchar2(4000) -- 出资比例
    ,revdate varchar2(4000) -- 吊销日期
    ,candate varchar2(4000) -- 注销日期
    ,enttype varchar2(4000) -- 企业（机构）类型
    ,ent_info_frinv varchar2(4000) -- 关联标签
    ,regorg varchar2(4000) -- 登记机关
    ,pinvamount varchar2(4000) -- 企业总数量
    ,name varchar2(4000) -- 公司名称
    ,regorgcode varchar2(4000) -- 注册地址行政编号
    ,esdate varchar2(4000) -- 成立日期
    ,regno varchar2(4000) -- 注册号
    ,entname varchar2(4000) -- 企业(机构)名称
    ,conform varchar2(4000) -- 出资方式
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
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv is '中数智慧';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.currency is '认缴出资币种代码';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.entstatus is '企业状态';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.regcap is '注册资本（企业:万元';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.subconam is '认缴出资额（万元）';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.regcapcur is '注册资本币种';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.creditcode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.fundedratio is '出资比例';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.revdate is '吊销日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.candate is '注销日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.enttype is '企业（机构）类型';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.ent_info_frinv is '关联标签';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.regorg is '登记机关';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.pinvamount is '企业总数量';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.name is '公司名称';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.regorgcode is '注册地址行政编号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.esdate is '成立日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.regno is '注册号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.entname is '企业(机构)名称';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.conform is '出资方式';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frinv.etl_timestamp is 'ETL处理时间戳';
