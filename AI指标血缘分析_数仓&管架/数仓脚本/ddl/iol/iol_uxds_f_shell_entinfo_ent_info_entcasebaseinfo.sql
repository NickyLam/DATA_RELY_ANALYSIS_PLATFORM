/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_entinfo_ent_info_entcasebaseinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,ent_info_entcasebaseinfo varchar2(4000) -- 业务关联
    ,illegacttype varchar2(4000) -- 违法行为类型
    ,penauth_cn varchar2(4000) -- 决定机关名称
    ,pencontent varchar2(4000) -- 行政处罚内容
    ,pendecissdate varchar2(4000) -- 处罚决定日期
    ,pendecno varchar2(4000) -- 决定书文号
    ,publicdate varchar2(4000) -- 公示日期
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
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo is '中数智汇企业查询_行政处罚基本信息';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo.ent_info_entcasebaseinfo is '业务关联';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo.illegacttype is '违法行为类型';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo.penauth_cn is '决定机关名称';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo.pencontent is '行政处罚内容';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo.pendecissdate is '处罚决定日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo.pendecno is '决定书文号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo.publicdate is '公示日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_entcasebaseinfo.etl_timestamp is 'ETL处理时间戳';
