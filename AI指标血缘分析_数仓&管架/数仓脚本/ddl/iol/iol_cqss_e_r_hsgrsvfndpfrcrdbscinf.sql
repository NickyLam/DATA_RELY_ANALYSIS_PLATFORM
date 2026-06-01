/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_hsgrsvfndpfrcrdbscinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,acc_id varchar2(9) -- 账户编号:ef05ai01
    ,first_py_yrmo varchar2(11) -- 初缴年月:ef05ar01
    ,emplnum number(22) -- 员工人数(职工人数):ef05as01
    ,hsgrsvfnd_pyf_crdnlt number(38,0) -- 住房公积金缴费基数(缴费基数):ef05aj01
    ,rctly_oc_pyf_dt date -- 最近一次缴费日期:ef05ar02
    ,hsgrsvfnd_pyt_yrmo varchar2(11) -- 住房公积金缴至年月(缴至年月):ef05ar03
    ,cr_hsgrsvfnd_pyf_stcd varchar2(30) -- 征信住房公积金缴费状态代码(缴费状态):ef05ad01
    ,acm_ow_amt number(38,0) -- 累计欠费金额:ef05aj02
    ,stat_yrmo varchar2(11) -- 统计年月:ef05ar04
    ,pyf_rcrd_num number(22) -- 缴费记录条数:ef05bs01
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
grant select on ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf is '住房公积金缴费记录基本信息';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf.acc_id is '账户编号:ef05ai01';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf.first_py_yrmo is '初缴年月:ef05ar01';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf.emplnum is '员工人数(职工人数):ef05as01';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf.hsgrsvfnd_pyf_crdnlt is '住房公积金缴费基数(缴费基数):ef05aj01';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf.rctly_oc_pyf_dt is '最近一次缴费日期:ef05ar02';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf.hsgrsvfnd_pyt_yrmo is '住房公积金缴至年月(缴至年月):ef05ar03';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf.cr_hsgrsvfnd_pyf_stcd is '征信住房公积金缴费状态代码(缴费状态):ef05ad01';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf.acm_ow_amt is '累计欠费金额:ef05aj02';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf.stat_yrmo is '统计年月:ef05ar04';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf.pyf_rcrd_num is '缴费记录条数:ef05bs01';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf.etl_timestamp is 'ETL处理时间戳';
