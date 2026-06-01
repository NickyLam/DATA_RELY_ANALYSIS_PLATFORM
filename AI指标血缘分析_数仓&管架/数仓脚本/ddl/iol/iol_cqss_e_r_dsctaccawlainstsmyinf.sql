/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_dsctaccawlainstsmyinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ed020i01
    ,inst_tp varchar2(45) -- 机构类型(业务管理机构类型):ed020d01
    ,mtit_ecd varchar2(192) -- 管理机构编码(业务管理机构代码):ed020i02
    ,repy_rspl_bnctg varchar2(9) -- 还款责任业务种类(业务种类):ed020d02
    ,pbc_lv5cl_cd varchar2(2) -- 人行征信五级分类(五级分类):ed020d03
    ,not_clsg_acc number(22) -- 未结清账户数:ed020s01
    ,bal_tot number(38,0) -- 余额合计:ed020j01
    ,odue_tamt_tot number(38,0) -- 逾期总额合计:ed020j02
    ,odue_pnp_tot number(38,0) -- 逾期本金合计:ed020j03
    ,alrdy_clsg_acc number(22) -- 已结清账户数:ed020s02
    ,alrdyclsgaccdstamttot number(38,0) -- 已结清账户贴现金额合计:ed020j04
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
grant select on ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf is '贴现账户分机构汇总信息';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.cr_inf_id is '征信信息编号:ed020i01';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.inst_tp is '机构类型(业务管理机构类型):ed020d01';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.mtit_ecd is '管理机构编码(业务管理机构代码):ed020i02';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.repy_rspl_bnctg is '还款责任业务种类(业务种类):ed020d02';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.pbc_lv5cl_cd is '人行征信五级分类(五级分类):ed020d03';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.not_clsg_acc is '未结清账户数:ed020s01';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.bal_tot is '余额合计:ed020j01';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.odue_tamt_tot is '逾期总额合计:ed020j02';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.odue_pnp_tot is '逾期本金合计:ed020j03';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.alrdy_clsg_acc is '已结清账户数:ed020s02';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.alrdyclsgaccdstamttot is '已结清账户贴现金额合计:ed020j04';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf.etl_timestamp is 'ETL处理时间戳';
