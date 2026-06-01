/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_relrepyrldaawaismyinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ed080i01
    ,rel_repy_rspl_tp varchar2(9) -- 相关还款责任类型:ed080d01
    ,inst_tp varchar2(45) -- 机构类型(业务管理机构类型):ed080d02
    ,mtit_ecd varchar2(192) -- 管理机构编码(业务管理机构代码):ed080i02
    ,repy_rspl_bnctg varchar2(9) -- 还款责任业务种类(业务种类细分):ed080d03
    ,pbc_lv5cl_cd varchar2(2) -- 人行征信五级分类(五级分类):ed080d04
    ,rel_repy_rspl_qot number(38,0) -- 相关还款责任限额:ed080j01
    ,acc_num number(22) -- 账户数:ed080s01
    ,bal number(38,0) -- 余额:ed080j02
    ,cur_odue_tamt number(38,0) -- 当前逾期总额(逾期总额):ed080j03
    ,cur_odue_pnp number(38,0) -- 当前逾期本金(逾期本金):ed080j04
    ,pbc_cr_lnd_amt number(38,0) -- 人行征信借款金额:ed080j05
    ,grnt_ctr_id varchar2(9) -- 保证合同编号:ed080i03
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
grant select on ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf is '相关还款责任贴现账户分机构汇总信息';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.cr_inf_id is '征信信息编号:ed080i01';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.rel_repy_rspl_tp is '相关还款责任类型:ed080d01';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.inst_tp is '机构类型(业务管理机构类型):ed080d02';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.mtit_ecd is '管理机构编码(业务管理机构代码):ed080i02';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.repy_rspl_bnctg is '还款责任业务种类(业务种类细分):ed080d03';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.pbc_lv5cl_cd is '人行征信五级分类(五级分类):ed080d04';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.rel_repy_rspl_qot is '相关还款责任限额:ed080j01';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.acc_num is '账户数:ed080s01';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.bal is '余额:ed080j02';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.cur_odue_tamt is '当前逾期总额(逾期总额):ed080j03';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.cur_odue_pnp is '当前逾期本金(逾期本金):ed080j04';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.pbc_cr_lnd_amt is '人行征信借款金额:ed080j05';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.grnt_ctr_id is '保证合同编号:ed080i03';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_relrepyrldaawaismyinf.etl_timestamp is 'ETL处理时间戳';
