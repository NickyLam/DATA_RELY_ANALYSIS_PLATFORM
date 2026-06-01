/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_instrument_ret1
CreateDate: 20250703
*/

set timing on
-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);

begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM ibms_ttrd_instrument_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('ibms_ttrd_instrument');

  if v_var <> 0 then
    execute immediate 'alter table ibms_ttrd_instrument drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table ibms_ttrd_instrument add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.ibms_ttrd_instrument (
	i_code -- 金融工具代码
	,a_type -- 资产类型
	,m_type -- 市场类型
	,currency -- 币种
	,i_name -- 金融工具名称
	,p_type -- 产品类型，用户不可修改，仅代码层面应用
	,p_class -- 产品分类，默认为资产类型名称，用户可以修改
	,p_ls -- 区分是long还是short（l：long；s：short）
	,mtr_date -- 到期日
	,term -- 如 1y，6m，7d
	,u_i_code -- 标的金融工具
	,u_a_type -- 标的资产类型
	,u_m_type -- 标的市场类型
	,coupon_type -- 息票类型：1－固定利率；2－浮动利率；3－零息票利率
	,issue_mode -- 发行模式：1－面值发行；2－贴现发行
	,payment_freq -- 付息周期,如 1y，6m，7d
	,cash_times -- 付息次数（一年付息几次）
	,seniority -- 清偿等级（仅用于债券）
	,party_id -- 发行机构id
	,chinesespell -- 中文简写
	,update_user -- 经办人
	,update_time -- 经办时间
	,account_user -- 复核人
	,account_time -- 复核时间
	,par_value -- 发行面额
	,fwd_irc -- 远期利率曲线
	,dis_irc -- 折现利率曲线
	,coupon -- 票面利率或利差
	,previous_version_mtr_date -- 上个版本的到期日,用于刷金融工具时指定从该日开始刷.当前该金融工具的到期指令的到期日为该日.修改时用该字段记录修改前的到期日,刷新指令时清除该值.
	,grp_id -- 组合号
	,term_day -- 期限天数
	,remain_term_day -- 剩余期限
	,issue_volume -- 发行数量
	,state -- 状态：0:正常状态  1：指令刷新中
	,i_id -- 机构号
	,start_date -- 起息日
	,weight_limit -- 风险权重
	,t_path -- 客户分类名称
	,p_class_act -- 会计产品分类
	,issuer_id -- 发行人id
	,warrantor_id -- 担保人id
	,issuer_t_path -- 发行人客户分类名称
	,b_actual_mtr_date -- 债券实际到期日
	,core_acct_code -- 定期帐号核心账户
	,q_currency -- 计价货币币种
	,is_spv_asset -- 是否spv资产0：否 1：是
	,real_i_code -- 实际金融工具代码
	,principal -- 本金
	,first_payment_date -- 首次付息日
	,daycount -- 计息基准
	,match_code -- 0
	,credit_classfy -- 授信分类
	,is_using_credit -- 是否占用授信，0-不占用，1-占用(仅非标使用)
	,credit_weight -- 授信权重(%)
	,apr_txn -- 批复编号
	,reply_code -- 额度合同编号
	,acting_code -- 记账科目号
	,prod_code -- 产品编码
	,tax_code -- 免税代码
	,charge_item -- 收费项
	,fee_number -- 费用编号
	,update_time2 -- 更新时间
	,is_renewal -- 续期标识
	,start_dt -- 开始时间
	,end_dt -- 结束时间
	,id_mark -- 增删标志
	,etl_timestamp -- ETL处理时间戳
)
select
	i_code as i_code -- 金融工具代码
	,a_type as a_type -- 资产类型
	,m_type as m_type -- 市场类型
	,currency as currency -- 币种
	,i_name as i_name -- 金融工具名称
	,p_type as p_type -- 产品类型，用户不可修改，仅代码层面应用
	,p_class as p_class -- 产品分类，默认为资产类型名称，用户可以修改
	,p_ls as p_ls -- 区分是long还是short（l：long；s：short）
	,mtr_date as mtr_date -- 到期日
	,term as term -- 如 1y，6m，7d
	,u_i_code as u_i_code -- 标的金融工具
	,u_a_type as u_a_type -- 标的资产类型
	,u_m_type as u_m_type -- 标的市场类型
	,coupon_type as coupon_type -- 息票类型：1－固定利率；2－浮动利率；3－零息票利率
	,issue_mode as issue_mode -- 发行模式：1－面值发行；2－贴现发行
	,payment_freq as payment_freq -- 付息周期,如 1y，6m，7d
	,cash_times as cash_times -- 付息次数（一年付息几次）
	,seniority as seniority -- 清偿等级（仅用于债券）
	,party_id as party_id -- 发行机构id
	,chinesespell as chinesespell -- 中文简写
	,update_user as update_user -- 经办人
	,update_time as update_time -- 经办时间
	,account_user as account_user -- 复核人
	,account_time as account_time -- 复核时间
	,par_value as par_value -- 发行面额
	,fwd_irc as fwd_irc -- 远期利率曲线
	,dis_irc as dis_irc -- 折现利率曲线
	,coupon as coupon -- 票面利率或利差
	,previous_version_mtr_date as previous_version_mtr_date -- 上个版本的到期日,用于刷金融工具时指定从该日开始刷.当前该金融工具的到期指令的到期日为该日.修改时用该字段记录修改前的到期日,刷新指令时清除该值.
	,grp_id as grp_id -- 组合号
	,term_day as term_day -- 期限天数
	,remain_term_day as remain_term_day -- 剩余期限
	,issue_volume as issue_volume -- 发行数量
	,state as state -- 状态：0:正常状态  1：指令刷新中
	,i_id as i_id -- 机构号
	,start_date as start_date -- 起息日
	,weight_limit as weight_limit -- 风险权重
	,t_path as t_path -- 客户分类名称
	,p_class_act as p_class_act -- 会计产品分类
	,issuer_id as issuer_id -- 发行人id
	,warrantor_id as warrantor_id -- 担保人id
	,issuer_t_path as issuer_t_path -- 发行人客户分类名称
	,b_actual_mtr_date as b_actual_mtr_date -- 债券实际到期日
	,core_acct_code as core_acct_code -- 定期帐号核心账户
	,q_currency as q_currency -- 计价货币币种
	,is_spv_asset as is_spv_asset -- 是否spv资产0：否 1：是
	,real_i_code as real_i_code -- 实际金融工具代码
	,principal as principal -- 本金
	,first_payment_date as first_payment_date -- 首次付息日
	,daycount as daycount -- 计息基准
	,match_code as match_code -- 0
	,credit_classfy as credit_classfy -- 授信分类
	,is_using_credit as is_using_credit -- 是否占用授信，0-不占用，1-占用(仅非标使用)
	,credit_weight as credit_weight -- 授信权重(%)
	,apr_txn as apr_txn -- 批复编号
	,reply_code as reply_code -- 额度合同编号
	,acting_code as acting_code -- 记账科目号
	,prod_code as prod_code -- 产品编码
	,tax_code as tax_code -- 免税代码
	,charge_item as charge_item -- 收费项
	,fee_number as fee_number -- 费用编号
	,' ' as update_time2 -- 更新时间
	,' ' as is_renewal -- 续期标识
	,start_dt as start_dt -- 开始时间
	,end_dt as end_dt -- 结束时间
	,id_mark as id_mark -- 增删标志
	,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_instrument_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

