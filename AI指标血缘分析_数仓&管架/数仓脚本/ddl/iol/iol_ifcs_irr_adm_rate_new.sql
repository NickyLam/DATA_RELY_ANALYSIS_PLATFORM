/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_irr_adm_rate_new
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_irr_adm_rate_new
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_irr_adm_rate_new purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_irr_adm_rate_new(
    data_dt varchar2(15) -- 数据日期
    ,org_num varchar2(18) -- 机构号
    ,business_typ varchar2(2) -- 业务大类1：存款2：资金3：贷款4：转贴现
    ,acct_typ varchar2(9) -- 业务细类
    ,corp_scale varchar2(3) -- 企业规模1：大型2：中型3：小型4：微型仅301-单位普通贷款需要提供
    ,rate_float_range varchar2(3) -- 利率浮动区：间指实际利率与基准利率的比值落在那个区间,仅存、贷款业务提供（不包括贴现、转贴现）
    ,amount number(20,4) -- 发生额：非活期性质的业务提供发生额（(贷款、转贴、定期性质存款、定期性质同业)）
    ,balance number(20,4) -- 余额:活期性质的业务提供的余额（活期、协定、通知、其他活期性质）
    ,orig_term_code varchar2(9) -- 原始期限代码
    ,int_rate_typ varchar2(9) -- 利率类型,仅 ”贷款“ 业务提供
    ,fina_code varchar2(30) -- 金融机构类型代码,仅资金业务提供
    ,curr_cd varchar2(5) -- 币种
    ,amt_typ varchar2(2) -- 大小额存款标识,仅外币”存款“提供
    ,max_int_rat number(20,6) -- 最高利率
    ,min_int_rat number(20,6) -- 最低利率
    ,ave_int_rat number(20,6) -- 加权利率
    ,max_amt number(20,4) -- 最高利率发生额或者余额
    ,min_amt number(20,4) -- 最低利率发生额或者余额
    ,tranway_flg varchar2(2) -- 网上网下交易标志1网上2网下,已经停用
    ,cust_typ varchar2(2) -- 客户类型1对公2对私
    ,agreement_typ varchar2(2) -- 协议存款人类别,仅”协议存款“需要提供
    ,srcsys_cd varchar2(2250) -- 源系统代码,数据源的业务系统代码。由银行根据自己系统情况自行编制
    ,fac_typ varchar2(2) -- 单户授信分类
    ,operate_cust_type varchar2(2) -- 经营性贷款主体类型
    ,float_type varchar2(5) -- 浮动利率参考类型
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
grant select on ${iol_schema}.ifcs_irr_adm_rate_new to ${iml_schema};
grant select on ${iol_schema}.ifcs_irr_adm_rate_new to ${icl_schema};
grant select on ${iol_schema}.ifcs_irr_adm_rate_new to ${idl_schema};
grant select on ${iol_schema}.ifcs_irr_adm_rate_new to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_irr_adm_rate_new is '利率报备接口表';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.data_dt is '数据日期';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.org_num is '机构号';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.business_typ is '业务大类1：存款2：资金3：贷款4：转贴现';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.acct_typ is '业务细类';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.corp_scale is '企业规模1：大型2：中型3：小型4：微型仅301-单位普通贷款需要提供';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.rate_float_range is '利率浮动区：间指实际利率与基准利率的比值落在那个区间,仅存、贷款业务提供（不包括贴现、转贴现）';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.amount is '发生额：非活期性质的业务提供发生额（(贷款、转贴、定期性质存款、定期性质同业)）';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.balance is '余额:活期性质的业务提供的余额（活期、协定、通知、其他活期性质）';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.orig_term_code is '原始期限代码';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.int_rate_typ is '利率类型,仅 ”贷款“ 业务提供';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.fina_code is '金融机构类型代码,仅资金业务提供';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.curr_cd is '币种';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.amt_typ is '大小额存款标识,仅外币”存款“提供';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.max_int_rat is '最高利率';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.min_int_rat is '最低利率';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.ave_int_rat is '加权利率';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.max_amt is '最高利率发生额或者余额';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.min_amt is '最低利率发生额或者余额';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.tranway_flg is '网上网下交易标志1网上2网下,已经停用';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.cust_typ is '客户类型1对公2对私';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.agreement_typ is '协议存款人类别,仅”协议存款“需要提供';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.srcsys_cd is '源系统代码,数据源的业务系统代码。由银行根据自己系统情况自行编制';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.fac_typ is '单户授信分类';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.operate_cust_type is '经营性贷款主体类型';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.float_type is '浮动利率参考类型';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.start_dt is '开始时间';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.end_dt is '结束时间';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.id_mark is '增删标志';
comment on column ${iol_schema}.ifcs_irr_adm_rate_new.etl_timestamp is 'ETL处理时间戳';
