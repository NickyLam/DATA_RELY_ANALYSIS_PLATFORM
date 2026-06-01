/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_salvation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_salvation
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_salvation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_salvation(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,crlwstensrhpstffcgycd varchar2(90) -- 征信最低保障帮助人员类别代码:pf06ad01
    ,cr_lwst_ensr_help_lo varchar2(450) -- 征信最低保障帮助所在地:pf06aq01
    ,crlwstensrhelpwrkunit varchar2(360) -- 征信最低保障帮助工作单位:pf06aq02
    ,crlwstensrhpfammoincm number(38,0) -- 征信最低保障帮助家庭月收入:pf06aq03
    ,crlwstensrhelpaply_dt date -- 征信最低保障帮助申请日期:pf06ar01
    ,crlwstensrhelprtfd_dt date -- 征信最低保障帮助批准日期:pf06ar02
    ,crlwstensrhepinfudtdt date -- 征信最低保障帮助信息更新日期:pf06ar03
    ,annttn_and_sttmnt_num number(22) -- 标注及声明个数
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
grant select on ${iol_schema}.cqss_i_r_salvation to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_salvation to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_salvation to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_salvation to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_salvation is '二代低保救助记录';
comment on column ${iol_schema}.cqss_i_r_salvation.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_salvation.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_salvation.crlwstensrhpstffcgycd is '征信最低保障帮助人员类别代码:pf06ad01';
comment on column ${iol_schema}.cqss_i_r_salvation.cr_lwst_ensr_help_lo is '征信最低保障帮助所在地:pf06aq01';
comment on column ${iol_schema}.cqss_i_r_salvation.crlwstensrhelpwrkunit is '征信最低保障帮助工作单位:pf06aq02';
comment on column ${iol_schema}.cqss_i_r_salvation.crlwstensrhpfammoincm is '征信最低保障帮助家庭月收入:pf06aq03';
comment on column ${iol_schema}.cqss_i_r_salvation.crlwstensrhelpaply_dt is '征信最低保障帮助申请日期:pf06ar01';
comment on column ${iol_schema}.cqss_i_r_salvation.crlwstensrhelprtfd_dt is '征信最低保障帮助批准日期:pf06ar02';
comment on column ${iol_schema}.cqss_i_r_salvation.crlwstensrhepinfudtdt is '征信最低保障帮助信息更新日期:pf06ar03';
comment on column ${iol_schema}.cqss_i_r_salvation.annttn_and_sttmnt_num is '标注及声明个数';
comment on column ${iol_schema}.cqss_i_r_salvation.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_salvation.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_salvation.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_salvation.etl_timestamp is 'ETL处理时间戳';
