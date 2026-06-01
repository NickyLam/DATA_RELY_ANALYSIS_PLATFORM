/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tfnd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tfnd
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tfnd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tfnd(
    i_code varchar2(45) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,l_code varchar2(45) -- 交易所本地代码
    ,currency varchar2(5) -- 币种
    ,country varchar2(3) -- 国家
    ,q_type varchar2(3) -- 报价方式
    ,f_name varchar2(225) -- 基金名称
    ,p_class varchar2(90) -- 产品分类
    ,f_date varchar2(15) -- 上市日期
    ,f_opendate varchar2(15) -- 开放日期
    ,f_manager varchar2(300) -- 管理者
    ,f_trustee varchar2(75) -- 托管方
    ,imp_date varchar2(15) -- 导入日期
    ,pipe_id number(22) -- 导入管道
    ,p_type varchar2(45) -- 产品类型
    ,chinesespell varchar2(300) -- 拼音
    ,state varchar2(2) -- 产品状态
    ,user_id number(19,0) -- 操作人id
    ,user_name varchar2(48) -- 操作人
    ,update_time varchar2(35) -- 操作时间
    ,f_manager_code varchar2(150) -- 管理者代码
    ,f_trustee_code varchar2(150) -- 托管方代码
    ,issuer_id number(16,0) -- 管理人id
    ,f_invest_type varchar2(60) -- 投资类型
    ,f_setupdate varchar2(15) -- 成立日期
    ,f_manager_name varchar2(15) -- 基金经理
    ,i_id number(19,0) -- 机构id
    ,is_idx varchar2(2) -- 是否指数型基金(0:否 1:是)
    ,huge_redemption_ratio number(31,4) -- 巨额赎回认定比例
    ,compounding_method number(22) -- 结转复利方式，0：单利；2：连续复利；仅对货币基金有效
    ,s_type varchar2(45) -- 标准类型
    ,f_mtrdate varchar2(15) -- 到期日期
    ,carry_forword_type varchar2(3) -- 结转方式：1：按日结转，2：按月结转，3：按季结转
    ,inv_order_id varchar2(75) -- 投金审批单号
    ,par_value number(20,6) -- 基金面值
    ,pay_freq varchar2(9) -- 结转频率，仅对货币基金有效
    ,f_grade_type number(22) -- 分级基金类型，0：非分级基金；1：分级母基金；2：分级子基金a类；3：分级子基金b类；
    ,f_fullname varchar2(300) -- 资产全称
    ,sales_channel varchar2(2) -- 销售通道0-直销,1-代销
    ,open_type varchar2(30) -- 每日开放：0,每周开放：1
    ,start_open_date varchar2(30) -- 开放周期开始日
    ,end_open_date varchar2(30) -- 开放周期结束日
    ,management_model varchar2(15) -- 管理模式
    ,mitigation_freq varchar2(15) -- 缓释频率
    ,manager_value varchar2(300) -- 
    ,main_code varchar2(45) -- 基金主代码(分级基金相同)
    ,f_name_full varchar2(300) -- 
    ,pay_month varchar2(9) -- 
    ,pay_day varchar2(9) -- 
    ,run_term varchar2(8) -- 
    ,p_i_code varchar2(45) -- 
    ,p_a_type varchar2(30) -- 
    ,p_m_type varchar2(30) -- 
    ,manager_id number(16,0) -- 
    ,redemption_date varchar2(15) -- 
    ,is_pub_offer varchar2(15) -- 
    ,this_open_end_date varchar2(15) -- 本周期开放终止日期
    ,this_hold_end_date varchar2(15) -- 本周期持有到期日期
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
grant select on ${iol_schema}.ibms_tfnd to ${iml_schema};
grant select on ${iol_schema}.ibms_tfnd to ${icl_schema};
grant select on ${iol_schema}.ibms_tfnd to ${idl_schema};
grant select on ${iol_schema}.ibms_tfnd to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tfnd is '基金表';
comment on column ${iol_schema}.ibms_tfnd.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_tfnd.a_type is '资产类型';
comment on column ${iol_schema}.ibms_tfnd.m_type is '市场类型';
comment on column ${iol_schema}.ibms_tfnd.l_code is '交易所本地代码';
comment on column ${iol_schema}.ibms_tfnd.currency is '币种';
comment on column ${iol_schema}.ibms_tfnd.country is '国家';
comment on column ${iol_schema}.ibms_tfnd.q_type is '报价方式';
comment on column ${iol_schema}.ibms_tfnd.f_name is '基金名称';
comment on column ${iol_schema}.ibms_tfnd.p_class is '产品分类';
comment on column ${iol_schema}.ibms_tfnd.f_date is '上市日期';
comment on column ${iol_schema}.ibms_tfnd.f_opendate is '开放日期';
comment on column ${iol_schema}.ibms_tfnd.f_manager is '管理者';
comment on column ${iol_schema}.ibms_tfnd.f_trustee is '托管方';
comment on column ${iol_schema}.ibms_tfnd.imp_date is '导入日期';
comment on column ${iol_schema}.ibms_tfnd.pipe_id is '导入管道';
comment on column ${iol_schema}.ibms_tfnd.p_type is '产品类型';
comment on column ${iol_schema}.ibms_tfnd.chinesespell is '拼音';
comment on column ${iol_schema}.ibms_tfnd.state is '产品状态';
comment on column ${iol_schema}.ibms_tfnd.user_id is '操作人id';
comment on column ${iol_schema}.ibms_tfnd.user_name is '操作人';
comment on column ${iol_schema}.ibms_tfnd.update_time is '操作时间';
comment on column ${iol_schema}.ibms_tfnd.f_manager_code is '管理者代码';
comment on column ${iol_schema}.ibms_tfnd.f_trustee_code is '托管方代码';
comment on column ${iol_schema}.ibms_tfnd.issuer_id is '管理人id';
comment on column ${iol_schema}.ibms_tfnd.f_invest_type is '投资类型';
comment on column ${iol_schema}.ibms_tfnd.f_setupdate is '成立日期';
comment on column ${iol_schema}.ibms_tfnd.f_manager_name is '基金经理';
comment on column ${iol_schema}.ibms_tfnd.i_id is '机构id';
comment on column ${iol_schema}.ibms_tfnd.is_idx is '是否指数型基金(0:否 1:是)';
comment on column ${iol_schema}.ibms_tfnd.huge_redemption_ratio is '巨额赎回认定比例';
comment on column ${iol_schema}.ibms_tfnd.compounding_method is '结转复利方式，0：单利；2：连续复利；仅对货币基金有效';
comment on column ${iol_schema}.ibms_tfnd.s_type is '标准类型';
comment on column ${iol_schema}.ibms_tfnd.f_mtrdate is '到期日期';
comment on column ${iol_schema}.ibms_tfnd.carry_forword_type is '结转方式：1：按日结转，2：按月结转，3：按季结转';
comment on column ${iol_schema}.ibms_tfnd.inv_order_id is '投金审批单号';
comment on column ${iol_schema}.ibms_tfnd.par_value is '基金面值';
comment on column ${iol_schema}.ibms_tfnd.pay_freq is '结转频率，仅对货币基金有效';
comment on column ${iol_schema}.ibms_tfnd.f_grade_type is '分级基金类型，0：非分级基金；1：分级母基金；2：分级子基金a类；3：分级子基金b类；';
comment on column ${iol_schema}.ibms_tfnd.f_fullname is '资产全称';
comment on column ${iol_schema}.ibms_tfnd.sales_channel is '销售通道0-直销,1-代销';
comment on column ${iol_schema}.ibms_tfnd.open_type is '每日开放：0,每周开放：1';
comment on column ${iol_schema}.ibms_tfnd.start_open_date is '开放周期开始日';
comment on column ${iol_schema}.ibms_tfnd.end_open_date is '开放周期结束日';
comment on column ${iol_schema}.ibms_tfnd.management_model is '管理模式';
comment on column ${iol_schema}.ibms_tfnd.mitigation_freq is '缓释频率';
comment on column ${iol_schema}.ibms_tfnd.manager_value is '';
comment on column ${iol_schema}.ibms_tfnd.main_code is '基金主代码(分级基金相同)';
comment on column ${iol_schema}.ibms_tfnd.f_name_full is '';
comment on column ${iol_schema}.ibms_tfnd.pay_month is '';
comment on column ${iol_schema}.ibms_tfnd.pay_day is '';
comment on column ${iol_schema}.ibms_tfnd.run_term is '';
comment on column ${iol_schema}.ibms_tfnd.p_i_code is '';
comment on column ${iol_schema}.ibms_tfnd.p_a_type is '';
comment on column ${iol_schema}.ibms_tfnd.p_m_type is '';
comment on column ${iol_schema}.ibms_tfnd.manager_id is '';
comment on column ${iol_schema}.ibms_tfnd.redemption_date is '';
comment on column ${iol_schema}.ibms_tfnd.is_pub_offer is '';
comment on column ${iol_schema}.ibms_tfnd.this_open_end_date is '本周期开放终止日期';
comment on column ${iol_schema}.ibms_tfnd.this_hold_end_date is '本周期持有到期日期';
comment on column ${iol_schema}.ibms_tfnd.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_tfnd.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_tfnd.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_tfnd.etl_timestamp is 'ETL处理时间戳';
