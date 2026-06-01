/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_entinfo_ent_info_frposition
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,entstatus varchar2(4000) -- 企业状态
    ,regcap varchar2(4000) -- 注册资本（企业:万元）
    ,regcapcur varchar2(4000) -- 注册资本币种
    ,creditcode varchar2(4000) -- 统一信用代码
    ,revdate varchar2(4000) -- 吊销日期
    ,candate varchar2(4000) -- 注销日期
    ,enttype varchar2(4000) -- 企业类型
    ,regorg varchar2(4000) -- 登记机关
    ,ppvamount varchar2(4000) -- 企业总数量
    ,lerepsign varchar2(4000) -- 是否法定代表人
    ,ent_info_frposition varchar2(4000) -- 关联标签
    ,name varchar2(4000) -- 公司名称
    ,regorgcode varchar2(4000) -- 注册地址行政编号
    ,position varchar2(4000) -- 职务
    ,esdate varchar2(4000) -- 成立日期
    ,regno varchar2(4000) -- 注册号
    ,entname varchar2(4000) -- 企业名称
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
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition is '中数智汇企业法定代表人其他公司任职';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.entstatus is '企业状态';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.regcap is '注册资本（企业:万元）';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.regcapcur is '注册资本币种';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.creditcode is '统一信用代码';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.revdate is '吊销日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.candate is '注销日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.enttype is '企业类型';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.regorg is '登记机关';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.ppvamount is '企业总数量';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.lerepsign is '是否法定代表人';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.ent_info_frposition is '关联标签';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.name is '公司名称';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.regorgcode is '注册地址行政编号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.position is '职务';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.esdate is '成立日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.regno is '注册号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.entname is '企业名称';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_frposition.etl_timestamp is 'ETL处理时间戳';
