/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_lbyhistsmyinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_lbyhistsmyinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_lbyhistsmyinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_lbyhistsmyinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,mo varchar2(11) -- 月份:eb02cr01
    ,whl_lby_acc number(22) -- 全部负债账户数:eb02cs02
    ,whl_lby_bal number(38,0) -- 全部负债余额:eb02cj01
    ,fcs_cgy_lby_acc number(22) -- 关注类负债账户数:eb02cs03
    ,fcs_cgy_lby_bal number(38,0) -- 关注类负债余额:eb02cj02
    ,bad_cgy_lby_acc number(22) -- 不良类负债账户数:eb02cs04
    ,bad_cgy_lby_bal number(38,0) -- 不良类负债余额:eb02cj03
    ,odue_acc number(22) -- 逾期账户数:eb02cs05
    ,cur_odue_tamt number(38,0) -- 当前逾期总额(逾期总额):eb02cj04
    ,odue_pnp_acc number(22) -- 逾期本金账户数:eb02cs06
    ,cur_odue_pnp number(38,0) -- 当前逾期本金(逾期本金):eb02cj05
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
grant select on ${iol_schema}.cqss_e_r_lbyhistsmyinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_lbyhistsmyinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_lbyhistsmyinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_lbyhistsmyinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_lbyhistsmyinf is '负债历史汇总信息';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.mo is '月份:eb02cr01';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.whl_lby_acc is '全部负债账户数:eb02cs02';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.whl_lby_bal is '全部负债余额:eb02cj01';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.fcs_cgy_lby_acc is '关注类负债账户数:eb02cs03';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.fcs_cgy_lby_bal is '关注类负债余额:eb02cj02';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.bad_cgy_lby_acc is '不良类负债账户数:eb02cs04';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.bad_cgy_lby_bal is '不良类负债余额:eb02cj03';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.odue_acc is '逾期账户数:eb02cs05';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.cur_odue_tamt is '当前逾期总额(逾期总额):eb02cj04';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.odue_pnp_acc is '逾期本金账户数:eb02cs06';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.cur_odue_pnp is '当前逾期本金(逾期本金):eb02cj05';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_lbyhistsmyinf.etl_timestamp is 'ETL处理时间戳';
