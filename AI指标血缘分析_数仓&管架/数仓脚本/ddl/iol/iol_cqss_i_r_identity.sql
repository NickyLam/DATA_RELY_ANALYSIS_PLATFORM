/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_identity
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_identity
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_identity purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_identity(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,gnd_cd varchar2(3) -- 性别代码:pb01ad01
    ,brth_dt date -- 出生日期:pb01ar01
    ,pbc_cr_eddgr varchar2(3) -- 人行征信学历:pb01ad02
    ,cr_dgr_cd varchar2(30) -- 征信学位代码:pb01ad03
    ,pbc_cr_emp_sttn varchar2(3) -- 人行征信就业状况:pb01ad04
    ,email_adr varchar2(270) -- 电子邮箱地址:pb01aq01
    ,cr_comm_adr varchar2(450) -- 征信通讯地址:pb01aq02
    ,nat_cd varchar2(5) -- 国籍代码:pb01ad05
    ,hshldrgst_adr varchar2(450) -- 户籍地址:pb01aq03
    ,ctc_tel_num number(22) -- 联系电话个数:pb01bs01
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
grant select on ${iol_schema}.cqss_i_r_identity to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_identity to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_identity to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_identity to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_identity is '二代身份信息';
comment on column ${iol_schema}.cqss_i_r_identity.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_identity.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_identity.gnd_cd is '性别代码:pb01ad01';
comment on column ${iol_schema}.cqss_i_r_identity.brth_dt is '出生日期:pb01ar01';
comment on column ${iol_schema}.cqss_i_r_identity.pbc_cr_eddgr is '人行征信学历:pb01ad02';
comment on column ${iol_schema}.cqss_i_r_identity.cr_dgr_cd is '征信学位代码:pb01ad03';
comment on column ${iol_schema}.cqss_i_r_identity.pbc_cr_emp_sttn is '人行征信就业状况:pb01ad04';
comment on column ${iol_schema}.cqss_i_r_identity.email_adr is '电子邮箱地址:pb01aq01';
comment on column ${iol_schema}.cqss_i_r_identity.cr_comm_adr is '征信通讯地址:pb01aq02';
comment on column ${iol_schema}.cqss_i_r_identity.nat_cd is '国籍代码:pb01ad05';
comment on column ${iol_schema}.cqss_i_r_identity.hshldrgst_adr is '户籍地址:pb01aq03';
comment on column ${iol_schema}.cqss_i_r_identity.ctc_tel_num is '联系电话个数:pb01bs01';
comment on column ${iol_schema}.cqss_i_r_identity.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_identity.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_identity.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_identity.etl_timestamp is 'ETL处理时间戳';
