/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_awlainstsmy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_awlainstsmy
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_awlainstsmy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_awlainstsmy(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ed050i01
    ,inst_tp varchar2(45) -- 机构类型(业务管理机构类型):ed050d01
    ,mtit_ecd varchar2(192) -- 管理机构编码(业务管理机构代码):ed050i02
    ,wrnt_bnctg_sbdvsn varchar2(6) -- 担保业务种类细分(担保交易种类细分):ed050d02
    ,pbc_lv5cl_cd varchar2(2) -- 人行征信五级分类(五级分类):ed050d03
    ,not_clsg_acc number(22) -- 未结清账户数:ed050s01
    ,bal number(38,0) -- 余额:ed050j01
    ,wrntacc30dinnrexpsbal number(38,0) -- 担保账户30天内到期的余额（30天内到期的余额）:ed050j02
    ,wrntacc60dinnrexpsbal number(38,0) -- 担保账户60天内到期的余额（60天内到期的余额）:ed050j03
    ,wrntacc90dinnrexpsbal number(38,0) -- 担保账户90天内到期的余额（90天内到期的余额）:ed050j04
    ,wrntacc90dyafexps_bal number(38,0) -- 担保账户90天后到期的余额（90天后到期的余额）:ed050j05
    ,alrdy_clsg_acc number(22) -- 已结清账户数:ed050s02
    ,adcsh_ind varchar2(2) -- 垫款标志:ed050d04
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
grant select on ${iol_schema}.cqss_e_r_awlainstsmy to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_awlainstsmy to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_awlainstsmy to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_awlainstsmy to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_awlainstsmy is '担保账户分机构汇总信息';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.cr_inf_id is '征信信息编号:ed050i01';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.inst_tp is '机构类型(业务管理机构类型):ed050d01';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.mtit_ecd is '管理机构编码(业务管理机构代码):ed050i02';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.wrnt_bnctg_sbdvsn is '担保业务种类细分(担保交易种类细分):ed050d02';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.pbc_lv5cl_cd is '人行征信五级分类(五级分类):ed050d03';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.not_clsg_acc is '未结清账户数:ed050s01';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.bal is '余额:ed050j01';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.wrntacc30dinnrexpsbal is '担保账户30天内到期的余额（30天内到期的余额）:ed050j02';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.wrntacc60dinnrexpsbal is '担保账户60天内到期的余额（60天内到期的余额）:ed050j03';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.wrntacc90dinnrexpsbal is '担保账户90天内到期的余额（90天内到期的余额）:ed050j04';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.wrntacc90dyafexps_bal is '担保账户90天后到期的余额（90天后到期的余额）:ed050j05';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.alrdy_clsg_acc is '已结清账户数:ed050s02';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.adcsh_ind is '垫款标志:ed050d04';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_awlainstsmy.etl_timestamp is 'ETL处理时间戳';
