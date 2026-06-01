/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_vtrd_fzywhq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_vtrd_fzywhq
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_vtrd_fzywhq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_fzywhq(
    obj_id varchar2(45) -- 核算id
    ,beg_date varchar2(15) -- 余额日期
    ,org_id varchar2(45) -- 机构号
    ,intordid varchar2(45) -- 交易单号
    ,secu_accname varchar2(180) -- 投组单元
    ,secu_acctg_type_name varchar2(90) -- 会计分类
    ,p_type_name varchar2(150) -- 产品类型
    ,p_class varchar2(150) -- 产品分类
    ,i_code varchar2(75) -- 金融工具代码
    ,i_name varchar2(383) -- 金融工具名称
    ,orddate varchar2(15) -- 交易日期
    ,partyname varchar2(383) -- 交易对手
    ,t_path varchar2(300) -- 交易对手客户分类
    ,currency varchar2(5) -- 币种
    ,ordamount number(22,0) -- 本金发生额
    ,bnd_aiamount number(31,4) -- 利息发生额
    ,bnd_ytm number(32,13) -- 执行利率/参考收益率
    ,open_date varchar2(15) -- 签约起始日
    ,end_date varchar2(15) -- 签约到期日
    ,first_payment_date varchar2(30) -- 首次付息日
    ,payment_freq_name varchar2(1500) -- 付息频率
    ,daycount_name varchar2(1500) -- 计息基准
    ,coupon_type_name varchar2(1500) -- 息票类型
    ,real_amount number(31,8) -- 余额
    ,business_category_name varchar2(1500) -- 所属行业门类
    ,business_category_min_name varchar2(383) -- 所属行业大类
    ,s_grade varchar2(32) -- 债项/主体评级
    ,exhacc varchar2(75) -- 本方账户
    ,party_acct_code varchar2(300) -- 交易对手账户
    ,trader varchar2(150) -- 经办人
    ,op_user_name1 varchar2(150) -- 总行经办人
    ,op_user_name2 varchar2(150) -- 总行复核人
    ,subj_code varchar2(150) -- 本金科目号
    ,ibs varchar2(5) -- 数据来源
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ibms_vtrd_fzywhq to ${iml_schema};
grant select on ${iol_schema}.ibms_vtrd_fzywhq to ${icl_schema};
grant select on ${iol_schema}.ibms_vtrd_fzywhq to ${idl_schema};
grant select on ${iol_schema}.ibms_vtrd_fzywhq to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_vtrd_fzywhq is '负债业务信息台账_活期';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.obj_id is '核算id';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.beg_date is '余额日期';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.org_id is '机构号';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.intordid is '交易单号';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.secu_accname is '投组单元';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.secu_acctg_type_name is '会计分类';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.p_type_name is '产品类型';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.p_class is '产品分类';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.i_name is '金融工具名称';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.orddate is '交易日期';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.partyname is '交易对手';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.t_path is '交易对手客户分类';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.currency is '币种';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.ordamount is '本金发生额';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.bnd_aiamount is '利息发生额';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.bnd_ytm is '执行利率/参考收益率';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.open_date is '签约起始日';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.end_date is '签约到期日';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.first_payment_date is '首次付息日';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.payment_freq_name is '付息频率';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.daycount_name is '计息基准';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.coupon_type_name is '息票类型';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.real_amount is '余额';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.business_category_name is '所属行业门类';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.business_category_min_name is '所属行业大类';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.s_grade is '债项/主体评级';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.exhacc is '本方账户';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.party_acct_code is '交易对手账户';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.trader is '经办人';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.op_user_name1 is '总行经办人';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.op_user_name2 is '总行复核人';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.subj_code is '本金科目号';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.ibs is '数据来源';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_vtrd_fzywhq.etl_timestamp is 'ETL处理时间戳';
