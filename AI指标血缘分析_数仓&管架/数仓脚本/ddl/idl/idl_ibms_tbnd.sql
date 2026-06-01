/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl ibms_tbnd
CreateDate: 20221105
FileType:   DDL
Logs:
    sundexin
*/

prompt creating table ${idl_schema}.ibms_tbnd
whenever sqlerror continue none;
drop table ${idl_schema}.ibms_tbnd purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.ibms_tbnd(
     etl_dt                             date                 -- 数据日期 
    ,i_code                             varchar2(30)         -- 金融工具代码                                                                                                                                                
    ,a_type                             varchar2(20)         -- 资产类型                                                                                                                                                  
    ,m_type                             varchar2(20)         -- 市场类型                                                                                                                                                  
    ,sh_code                            varchar2(30)         -- 上交所代码                                                                                                                                                 
    ,sz_code                            varchar2(30)         -- 深交所代码                                                                                                                                                 
    ,yh_code                            varchar2(30)         -- 银行间代码                                                                                                                                                 
    ,currency                           char(3)              -- 币种                                                                                                                                                    
    ,country                            char(2)              -- 国家                                                                                                                                                    
    ,q_type                             char(2)              -- 报价方式                                                                                                                                                  
    ,b_name                             varchar2(200)        -- 债券名称                                                                                                                                                  
    ,p_type                             varchar2(30)         -- 产品类型                                                                                                                                                  
    ,p_class                            varchar2(60)         -- 产品分类                                                                                                                                                  
    ,b_par_value                        number(31,8)         -- 面额                                                                                                                                                    
    ,b_issue_price                      number(12,4)         -- 发行价格                                                                                                                                                  
    ,b_issue_date                       char(10)             -- 发行日期                                                                                                                                                  
    ,b_list_date                        char(10)             -- 上市时间                                                                                                                                                  
    ,b_start_date                       char(10)             -- 起息日                                                                                                                                                   
    ,b_mtr_date                         char(10)             -- 到期日                                                                                                                                                   
    ,b_term                             varchar2(6)          -- 期限                                                                                                                                                    
    ,b_daycount                         varchar2(120)        -- 计息基准                                                                                                                                                  
    ,i_code_bench                       varchar2(100)        -- 基准利率代码                                                                                                                                                
    ,a_type_bench                       varchar2(20)         -- 基准利率资产类型                                                                                                                                              
    ,m_type_bench                       varchar2(20)         -- 基准利率市场类型                                                                                                                                              
    ,b_issue_mode                       char(1)              -- 发行方式                                                                                                                                                  
    ,b_coupon_type                      char(1)              -- 票息类型                                                                                                                                                  
    ,b_cash_times                       number               -- 付息次数                                                                                                                                                  
    ,b_embopt_type                      varchar2(10)         -- 含权类型                                                                                                                                                  
    ,b_amortizing                       char(1)              -- 本金偿还类型                                                                                                                                                
    ,b_as_type                          varchar2(30)         -- 资产化类型                                                                                                                                                 
    ,b_issuer                           varchar2(200)        -- 发行机构                                                                                                                                                  
    ,b_warrantor                        varchar2(1000)       -- 担保机构                                                                                                                                                  
    ,b_seniority                        varchar2(20)         -- 清偿等级                                                                                                                                                  
    ,b_fpml                             clob                 -- 条款FPML                                                                                                                                                
    ,b_coupon                           number(12,6)         -- 利率/利差                                                                                                                                                 
    ,b_name_full                        varchar2(500)        -- 债券全称                                                                                                                                                  
    ,b_actual_mtr_date                  char(10)             -- 实际到期日                                                                                                                                                 
    ,d_code                             varchar2(40)         -- 债券内部代码                                                                                                                                                
    ,b_p_class                          varchar2(60)         -- 债券产品分类                                                                                                                                                
    ,b_actual_issue_amount              number(38,8)         -- 实际发行量                                                                                                                                                 
    ,chinesespell                       varchar2(50)         -- 中文拼写                                                                                                                                                 
    ,b_coupon_prec                      number               -- 中文拼写                                                                                                                                                 
    ,host_market                        varchar2(20)         -- 利率精度                                                                                                                                                  
    ,bj_market                          varchar2(20)         -- 托管市场                                                                                                                                                  
    ,issuer_id                          number               -- 薄记市场                                                                                                                                                  
    ,warrantor_id                       number               -- 发行人ID                                                                                                                                                 
    ,is_delete                          number               -- 担保人ID                                                                                                                                                 
    ,usable_flag                        number               -- 是否删除                                                                                                                                                  
    ,memo                               varchar2(2000)       -- 是否已生效：1： 正常 2： 新增                                                                                                                                     
    ,update_user                        varchar2(30)         -- 备注                                                                                                                                                    
    ,account_user                       varchar2(30)         -- 更新人员                                                                                                                                                  
    ,update_time                        varchar2(20)         -- 复核人员                                                                                                                                                  
    ,account_time                       varchar2(20)         -- 更新时间                                                                                                                                                  
    ,imp_date                           char(10)             -- 复核时间                                                                                                                                                  
    ,imp_time                           varchar2(19)         -- 导入日期                                                                                                                                                  
    ,pipe_id                            number               -- 导入时间                                                                                                                                                  
    ,b_fst_pay_date                     char(10)             -- 导入管道                                                                                                                                                  
    ,b_fst_reg_calc_start_date          char(10)             -- 首个付息日                                                                                                                                                 
    ,b_initial_fixing_date              char(10)             -- 首个规则计息区间开始日                                                                                                                                           
    ,b_pay_freq                         varchar2(6)          -- 首周期定息日                                                                                                                                                
    ,b_pay_bizday_convertion            varchar2(30)         -- 支付频率                                                                                                                                                  
    ,b_calc_freq                        varchar2(6)          -- 支付调整规则                                                                                                                                                
    ,b_calc_bizday_convertion           varchar2(30)         -- 计息频率                                                                                                                                                  
    ,b_reset_freq                       varchar2(6)          -- 计息调整规则                                                                                                                                                
    ,b_reset_bizday_convertion          varchar2(30)         -- 重置频率                                                                                                                                                  
    ,b_fixing_dates_offset              varchar2(6)          -- 重置调整规则                                                                                                                                                
    ,b_fixing_bizday_convertion         varchar2(30)         -- 定息日偏移                                                                                                                                                 
    ,b_fixing_precision                 number               -- 定息日调整规则                                                                                                                                               
    ,b_initial_rate                     number(12,6)         -- 定息精度，普通债券为4，少量债券为6                                                                                                                                    
    ,b_multiplier                       number(6,4)          -- 首周期定息利率                                                                                                                                               
    ,b_cap_rate                         number(12,6)         -- 初始利率倍数                                                                                                                                                
    ,b_floor_rate                       number(12,6)         -- 初始利率上限                                                                                                                                                
    ,b_exercise_style                   char(1)              -- 初始利率下限                                                                                                                                                
    ,b_exercise_date                    char(10)             -- 行权类型，A：美式 B：百慕大 E：欧式                                                                                                                                  
    ,b_strike_price                     number(12,4)         -- 首个行权日，含权债有效                                                                                                                                           
    ,b_compensation_rate                number(12,6)         -- 首个执行价格，含权债有效                                                                                                                                          
    ,p_class_act                        varchar2(60)         -- 首个补偿利率，含权债有效                                                                                                                                          
    ,b_issuer_code                      varchar2(100)        -- 会计产品分类                                                                                                                                                
    ,special_desc                       varchar2(4000)       -- 发行人代码                                                                                                                                                 
    ,b_actual_amount_rate               number(38,4)         -- 特殊条款说明                                                                                                                                                
    ,trustenhancing_type                varchar2(50)         -- 发行额度占比（%）                                                                                                                                             
    ,b_issue_list_date                  char(10)             -- 增信方式                                                                                                                                                  
    ,issue_feerate                      number(20,4)         -- 上市公告日期                                                                                                                                                
    ,underwriting_type                  varchar2(100)        -- 发行费率                                                                                                                                                  
    ,b_extend_type                      varchar2(100)        -- 承销方式                                                                                                                                                  
    ,s_type                             varchar2(30)         -- 债券扩展字段 第1位：是否可转股；第2位：是否可赎回；第3位：是否可回售；第4位：是否可转为相关债券（固息转浮息、浮息转固息)；第5位: 是否公开发行；第6位：是否永续；第7位：是否自贸区；第8位：是否权益类标识；第9位：利率债/信用债；第10位：减记条款；第11位：违约标记；第12位：临时债券标记
    ,p_class_dv                         varchar2(60)         -- 标准类型                                                                                                                                                  
    ,p_class_ccdc                       varchar2(60)         -- 数据厂商债券分类                                                                                                                                              
    ,q_par_value                        number(20,6)         -- 中债债券分类                                                                                                                                                
    ,confirm_term                       char(1)              -- 报价面值，0：报价以债券面值报价；其它值为报价面值                                                                                                                             
    ,sec_code                           varchar2(100)        -- 是否完整条款，1：不完整条款；0或空值：完整条款                                                                                                                              
    ,public_issue                       char(1)              -- 证券唯一编码                                                                                                                                                
    ,b_user_mtr_date                    char(10)             -- 是否公开发行，0：否；1：是                                                                                                                                        
    ,ai_daycount                        varchar2(30)         -- 用户指定到期日                                                                                                                                               
    ,ytm_daycount                       varchar2(30)         -- 应计利息计息基准                                                                                                                                              
    ,b_early_mtr_date                   char(10)             -- 到期收益率计息基准                                                                                                                                             
    ,manage_mode                        varchar2(10)         -- 提前到期日                                                                                                                                                 
    ,bond_nature                        varchar2(10)         -- 管理模式,1:自主管理；2:委托管理,默认1                                                                                                                                
    ,is_city_investment                 char(1)              -- 债券性质                                                                                                                                                  
    ,perpetual                          char(1)              -- 是否城投债                                                                                                                                                 
    ,legal_mtr_date                     char(10)             -- 是否永续债                                                                                                                                                 
    ,b_plan_issue_amount                number(31,8)         -- 法定到期日                                                                                                                                                 
    ,is_default                         char(1)              -- 计划发行量                                                                                                                                                 
    ,cf_daycount                        varchar2(30)         -- 是否违约                                                                                                                                                  
    ,ai_daycount_back                   varchar2(30)         -- 前台现金流计息基准                                                                                                                                             
    ,ytm_daycount_back                  varchar2(30)         -- 后台应计利息计息基准                                                                                                                                            
    ,cf_daycount_back                   varchar2(30)         -- 后台到期收益率计息基准                                                                                                                                           
    ,is_temp                            number(1)            -- 后台现金流计息基准                                                                                                                                             
    ,b_ext_rating                       varchar2(10)         -- 是否临时代码，0：否；1：是                                                                                                                                        
    ,b_ext_rating_institution           varchar2(100)        -- 最新债项评级                                                                                                                                                
    ,b_issuer_ext_rating                varchar2(10)         -- 最新债项评级机构                                                                                                                                              
    ,b_issuer_ext_r_institution         varchar2(100)        -- 最新发行人评级                                                                                                                                               
    ,b_fst_ext_rating                   varchar2(10)         -- 最新发行人评级机构                                                                                                                                             
    ,b_fst_ext_rating_inst              varchar2(100)        -- 债项首次评级                                                                                                                                                
    ,b_fst_issuer_ext_rating            varchar2(10)         -- 债项首次评级机构                                                                                                                                              
    ,b_fst_issuer_ext_r_inst            varchar2(100)        -- 发行人首次评级                                                                                                                                               
    ,b_as_asset_type_name               varchar2(100)        -- 发行人首次评级机构                                                                                                                                             
    ,ref_yield                          number(12,6)         -- 基础资产类型名称(仅对ABS债券有效)                                                                                                                                   
    ,warrantor_responsibility           char(1)              -- 参考收益率                                                                                                                                                 
    ,debts_registration_date            varchar2(10)         -- 担保人是否有连带责任,0-否,1-是                                                                                                                                    
    ,guarantor_rating                   number(10,2)         -- 债权债务登记日                                                                                                                                               
    ,start_dt                           date                 -- 担保人评级                                                                                                                                                 
    ,end_dt                             date                 -- 开始时间                                                                                                                                                  
    ,id_mark                            varchar2(10)         -- 结束时间                                                                                                                                                  
    ,etl_timestamp                      timestamp            -- 数据增删标志                                                                                                                                                  处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.ibms_tbnd to ${iel_schema};
grant select on ${idl_schema}.ibms_tbnd to ${icl_schema};

-- comment
comment on table ${idl_schema}.ibms_tbnd is '债券基本信息表';
comment on column ${idl_schema}.ibms_tbnd.i_code is '金融工具代码';
comment on column ${idl_schema}.ibms_tbnd.a_type is '资产类型';
comment on column ${idl_schema}.ibms_tbnd.m_type is '市场类型';
comment on column ${idl_schema}.ibms_tbnd.sh_code is '上交所代码';
comment on column ${idl_schema}.ibms_tbnd.sz_code is '深交所代码';
comment on column ${idl_schema}.ibms_tbnd.yh_code is '银行间代码';
comment on column ${idl_schema}.ibms_tbnd.currency is '币种';
comment on column ${idl_schema}.ibms_tbnd.country is '国家';
comment on column ${idl_schema}.ibms_tbnd.q_type is '报价方式';
comment on column ${idl_schema}.ibms_tbnd.b_name is '债券名称';
comment on column ${idl_schema}.ibms_tbnd.p_type is '产品类型';
comment on column ${idl_schema}.ibms_tbnd.p_class is '产品分类';
comment on column ${idl_schema}.ibms_tbnd.b_par_value is '面额';
comment on column ${idl_schema}.ibms_tbnd.b_issue_price is '发行价格';
comment on column ${idl_schema}.ibms_tbnd.b_issue_date is '发行日期';
comment on column ${idl_schema}.ibms_tbnd.b_list_date is '上市时间';
comment on column ${idl_schema}.ibms_tbnd.b_start_date is '起息日';
comment on column ${idl_schema}.ibms_tbnd.b_mtr_date is '到期日';
comment on column ${idl_schema}.ibms_tbnd.b_term is '期限';
comment on column ${idl_schema}.ibms_tbnd.b_daycount is '计息基准';
comment on column ${idl_schema}.ibms_tbnd.i_code_bench is '基准利率代码';
comment on column ${idl_schema}.ibms_tbnd.a_type_bench is '基准利率资产类型';
comment on column ${idl_schema}.ibms_tbnd.m_type_bench is '基准利率市场类型';
comment on column ${idl_schema}.ibms_tbnd.b_issue_mode is '发行方式';
comment on column ${idl_schema}.ibms_tbnd.b_coupon_type is '票息类型';
comment on column ${idl_schema}.ibms_tbnd.b_cash_times is '付息次数';
comment on column ${idl_schema}.ibms_tbnd.b_embopt_type is '含权类型';
comment on column ${idl_schema}.ibms_tbnd.b_amortizing is '本金偿还类型';
comment on column ${idl_schema}.ibms_tbnd.b_as_type is '资产化类型';
comment on column ${idl_schema}.ibms_tbnd.b_issuer is '发行机构';
comment on column ${idl_schema}.ibms_tbnd.b_warrantor is '担保机构';
comment on column ${idl_schema}.ibms_tbnd.b_seniority is '清偿等级';
comment on column ${idl_schema}.ibms_tbnd.b_fpml is '条款fpml';
comment on column ${idl_schema}.ibms_tbnd.b_coupon is '利率/利差';
comment on column ${idl_schema}.ibms_tbnd.b_name_full is '债券全称';
comment on column ${idl_schema}.ibms_tbnd.b_actual_mtr_date is '实际到期日';
comment on column ${idl_schema}.ibms_tbnd.d_code is '债券内部代码';
comment on column ${idl_schema}.ibms_tbnd.b_p_class is '债券产品分类';
comment on column ${idl_schema}.ibms_tbnd.b_actual_issue_amount is '实际发行量';
comment on column ${idl_schema}.ibms_tbnd.chinesespell is '中文拼写中文拼写';
comment on column ${idl_schema}.ibms_tbnd.b_coupon_prec is '利率精度';
comment on column ${idl_schema}.ibms_tbnd.host_market is '托管市场';
comment on column ${idl_schema}.ibms_tbnd.bj_market is '薄记市场';
comment on column ${idl_schema}.ibms_tbnd.issuer_id is '发行人id';
comment on column ${idl_schema}.ibms_tbnd.warrantor_id is '担保人id';
comment on column ${idl_schema}.ibms_tbnd.is_delete is '是否删除';
comment on column ${idl_schema}.ibms_tbnd.usable_flag is '是否已生效：1： 正常 2： 新增';
comment on column ${idl_schema}.ibms_tbnd.memo is '备注';
comment on column ${idl_schema}.ibms_tbnd.update_user is '更新人员';
comment on column ${idl_schema}.ibms_tbnd.account_user is '复核人员';
comment on column ${idl_schema}.ibms_tbnd.update_time is '更新时间';
comment on column ${idl_schema}.ibms_tbnd.account_time is '复核时间';
comment on column ${idl_schema}.ibms_tbnd.imp_date is '导入日期';
comment on column ${idl_schema}.ibms_tbnd.imp_time is '导入时间';
comment on column ${idl_schema}.ibms_tbnd.pipe_id is '导入管道';
comment on column ${idl_schema}.ibms_tbnd.b_fst_pay_date is '首个付息日';
comment on column ${idl_schema}.ibms_tbnd.b_fst_reg_calc_start_date is '首个规则计息区间开始日';
comment on column ${idl_schema}.ibms_tbnd.b_initial_fixing_date is '首周期定息日';
comment on column ${idl_schema}.ibms_tbnd.b_pay_freq is '支付频率';
comment on column ${idl_schema}.ibms_tbnd.b_pay_bizday_convertion is '支付调整规则';
comment on column ${idl_schema}.ibms_tbnd.b_calc_freq is '计息频率';
comment on column ${idl_schema}.ibms_tbnd.b_calc_bizday_convertion is '计息调整规则';
comment on column ${idl_schema}.ibms_tbnd.b_reset_freq is '重置频率';
comment on column ${idl_schema}.ibms_tbnd.b_reset_bizday_convertion is '重置调整规则';
comment on column ${idl_schema}.ibms_tbnd.b_fixing_dates_offset is '定息日偏移';
comment on column ${idl_schema}.ibms_tbnd.b_fixing_bizday_convertion is '定息日调整规则';
comment on column ${idl_schema}.ibms_tbnd.b_fixing_precision is '定息精度，普通债券为4，少量债券为6';
comment on column ${idl_schema}.ibms_tbnd.b_initial_rate is '首周期定息利率';
comment on column ${idl_schema}.ibms_tbnd.b_multiplier is '初始利率倍数';
comment on column ${idl_schema}.ibms_tbnd.b_cap_rate is '初始利率上限';
comment on column ${idl_schema}.ibms_tbnd.b_floor_rate is '初始利率下限';
comment on column ${idl_schema}.ibms_tbnd.b_exercise_style is '行权类型，a：美式 b：百慕大 e：欧式';
comment on column ${idl_schema}.ibms_tbnd.b_exercise_date is '首个行权日，含权债有效';
comment on column ${idl_schema}.ibms_tbnd.b_strike_price is '首个执行价格，含权债有效';
comment on column ${idl_schema}.ibms_tbnd.b_compensation_rate is '首个补偿利率，含权债有效';
comment on column ${idl_schema}.ibms_tbnd.p_class_act is '会计产品分类';
comment on column ${idl_schema}.ibms_tbnd.b_issuer_code is '发行人代码';
comment on column ${idl_schema}.ibms_tbnd.special_desc is '特殊条款说明';
comment on column ${idl_schema}.ibms_tbnd.b_actual_amount_rate is '发行额度占比（%）';
comment on column ${idl_schema}.ibms_tbnd.trustenhancing_type is '增信方式';
comment on column ${idl_schema}.ibms_tbnd.b_issue_list_date is '上市公告日期';
comment on column ${idl_schema}.ibms_tbnd.issue_feerate is '发行费率';
comment on column ${idl_schema}.ibms_tbnd.underwriting_type is '承销方式';
comment on column ${idl_schema}.ibms_tbnd.b_extend_type is '债券扩展字段 第1位：是否可转股；第2位：是否可赎回；第3位：是否可回售；第4位：是否可转为相关债券（固息转浮息、浮息转固息)；第5位: 是否公开发行；第6位：是否永续；第7位：是否自贸区；第8位：是否权益类标识；第9位：利率债/信用债；第10位：减记条款；第11位：违约标记；第12位：临时债券标记';
comment on column ${idl_schema}.ibms_tbnd.s_type is '标准类型';
comment on column ${idl_schema}.ibms_tbnd.p_class_dv is '数据厂商债券分类';
comment on column ${idl_schema}.ibms_tbnd.p_class_ccdc is '中债债券分类';
comment on column ${idl_schema}.ibms_tbnd.q_par_value is '报价面值，0：报价以债券面值报价；其它值为报价面值';
comment on column ${idl_schema}.ibms_tbnd.confirm_term is '是否完整条款，1：不完整条款；0或空值：完整条款';
comment on column ${idl_schema}.ibms_tbnd.sec_code is '证券唯一编码';
comment on column ${idl_schema}.ibms_tbnd.public_issue is '是否公开发行，0：否；1：是';
comment on column ${idl_schema}.ibms_tbnd.b_user_mtr_date is '用户指定到期日';
comment on column ${idl_schema}.ibms_tbnd.ai_daycount is '应计利息计息基准';
comment on column ${idl_schema}.ibms_tbnd.ytm_daycount is '到期收益率计息基准';
comment on column ${idl_schema}.ibms_tbnd.b_early_mtr_date is '提前到期日';
comment on column ${idl_schema}.ibms_tbnd.manage_mode is '管理模式,1:自主管理；2:委托管理,默认1';
comment on column ${idl_schema}.ibms_tbnd.bond_nature is '债券性质';
comment on column ${idl_schema}.ibms_tbnd.is_city_investment is '是否城投债';
comment on column ${idl_schema}.ibms_tbnd.perpetual is '是否永续债';
comment on column ${idl_schema}.ibms_tbnd.legal_mtr_date is '法定到期日';
comment on column ${idl_schema}.ibms_tbnd.b_plan_issue_amount is '计划发行量';
comment on column ${idl_schema}.ibms_tbnd.is_default is '是否违约';
comment on column ${idl_schema}.ibms_tbnd.cf_daycount is '前台现金流计息基准';
comment on column ${idl_schema}.ibms_tbnd.ai_daycount_back is '后台应计利息计息基准';
comment on column ${idl_schema}.ibms_tbnd.ytm_daycount_back is '后台到期收益率计息基准';
comment on column ${idl_schema}.ibms_tbnd.cf_daycount_back is '后台现金流计息基准';
comment on column ${idl_schema}.ibms_tbnd.is_temp is '是否临时代码，0：否；1：是';
comment on column ${idl_schema}.ibms_tbnd.b_ext_rating is '最新债项评级';
comment on column ${idl_schema}.ibms_tbnd.b_ext_rating_institution is '最新债项评级机构';
comment on column ${idl_schema}.ibms_tbnd.b_issuer_ext_rating is '最新发行人评级';
comment on column ${idl_schema}.ibms_tbnd.b_issuer_ext_r_institution is '最新发行人评级机构';
comment on column ${idl_schema}.ibms_tbnd.b_fst_ext_rating is '债项首次评级';
comment on column ${idl_schema}.ibms_tbnd.b_fst_ext_rating_inst is '债项首次评级机构';
comment on column ${idl_schema}.ibms_tbnd.b_fst_issuer_ext_rating is '发行人首次评级';
comment on column ${idl_schema}.ibms_tbnd.b_fst_issuer_ext_r_inst is '发行人首次评级机构';
comment on column ${idl_schema}.ibms_tbnd.b_as_asset_type_name is '基础资产类型名称(仅对abs债券有效)';
comment on column ${idl_schema}.ibms_tbnd.ref_yield is '参考收益率';
comment on column ${idl_schema}.ibms_tbnd.warrantor_responsibility is '担保人是否有连带责任,0-否,1-是';
comment on column ${idl_schema}.ibms_tbnd.debts_registration_date is '债权债务登记日';
comment on column ${idl_schema}.ibms_tbnd.guarantor_rating is '担保人评级';
comment on column ${idl_schema}.ibms_tbnd.start_dt is '开始时间';
comment on column ${idl_schema}.ibms_tbnd.end_dt is '结束时间';
comment on column ${idl_schema}.ibms_tbnd.id_mark is '增删标志';
comment on column ${idl_schema}.ibms_tbnd.etl_timestamp is '数据处理时间';
