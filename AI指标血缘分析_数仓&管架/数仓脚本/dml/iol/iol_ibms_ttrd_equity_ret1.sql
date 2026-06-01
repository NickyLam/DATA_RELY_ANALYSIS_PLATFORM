/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_equity_ret1
CreateDate: 20250207
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
                       FROM ibms_ttrd_equity_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('ibms_ttrd_equity');

  if v_var <> 0 then
    execute immediate 'alter table ibms_ttrd_equity drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table ibms_ttrd_equity add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.ibms_ttrd_equity (
    i_code -- 金融工具代码
    ,a_type -- 资产类型：净值型项目spt_ntp
    ,m_type -- 市场类型
    ,l_code -- 本地代码
    ,i_name -- 金融工具名称
    ,currency -- 币种
    ,country -- 国家
    ,q_type -- 发行类型：净值型
    ,p_type -- 产品类型
    ,p_class -- 产品分类
    ,list_date -- 上市时间
    ,open_date -- 开发时间
    ,issuer -- 发行人
    ,risk_rating -- 风险等级
    ,trustee -- 托管人
    ,imp_date -- 导入日期
    ,pipe_id -- 导入方式
    ,chinesespell -- 拼音简称
    ,update_user -- 
    ,update_time -- 
    ,account_user -- 
    ,account_time -- 
    ,issuer_id -- 发行机构id
    ,trustee_id -- 托管机构id
    ,usable_flag -- 是否已生效：1： 正常 0： 新增
    ,product_rate -- 产品评级
    ,rate_institution -- 评级机构
    ,open_type -- 每日开放：0,每周开放：1
    ,start_open_date -- 开放周期开始日
    ,end_open_date -- 开放周期结束日
    ,guarantee_way -- 担保方式
    ,guarantee_infor -- 担保物情况
    ,ctrct_id -- 合同编号
    ,platform -- 平台
    ,invest_direction -- 投向
    ,final_invest -- 最终投向类型
    ,five_class -- 五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）
    ,contract_version -- 合同版本号（已审合同:0,送审合同:1,标准合同:2）
    ,extordid -- 外部交易号
    ,mitigation_freq -- 缓释频率
    ,manager_id -- 实际管理人id
    ,manager_value -- 实际管理人
    ,risk_proportion -- 风险权重占比
    ,middle_classify -- 业务中类
    ,small_classify -- 业务小类
    ,closing_start_date -- 封闭开始日(对应开放类型为封闭型)
    ,closing_end_date -- 封闭结束日(对应开放类型为封闭型)
    ,curr_open_break_date -- 本周期开放终止日期
    ,curr_hold_end_date -- 本周期持有到期日期
    ,update_time2 -- 更新时间
    ,refer_code -- 参照代码
    ,is_cash_manage_type -- 是否现金管理类产品
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    i_code as i_code -- 金融工具代码
    ,a_type as a_type -- 资产类型：净值型项目spt_ntp
    ,m_type as m_type -- 市场类型
    ,l_code as l_code -- 本地代码
    ,i_name as i_name -- 金融工具名称
    ,currency as currency -- 币种
    ,country as country -- 国家
    ,q_type as q_type -- 发行类型：净值型
    ,p_type as p_type -- 产品类型
    ,p_class as p_class -- 产品分类
    ,list_date as list_date -- 上市时间
    ,open_date as open_date -- 开发时间
    ,issuer as issuer -- 发行人
    ,risk_rating as risk_rating -- 风险等级
    ,trustee as trustee -- 托管人
    ,imp_date as imp_date -- 导入日期
    ,pipe_id as pipe_id -- 导入方式
    ,chinesespell as chinesespell -- 拼音简称
    ,update_user as update_user -- 
    ,update_time as update_time -- 
    ,account_user as account_user -- 
    ,account_time as account_time -- 
    ,issuer_id as issuer_id -- 发行机构id
    ,trustee_id as trustee_id -- 托管机构id
    ,usable_flag as usable_flag -- 是否已生效：1： 正常 0： 新增
    ,product_rate as product_rate -- 产品评级
    ,rate_institution as rate_institution -- 评级机构
    ,open_type as open_type -- 每日开放：0,每周开放：1
    ,start_open_date as start_open_date -- 开放周期开始日
    ,end_open_date as end_open_date -- 开放周期结束日
    ,guarantee_way as guarantee_way -- 担保方式
    ,guarantee_infor as guarantee_infor -- 担保物情况
    ,ctrct_id as ctrct_id -- 合同编号
    ,platform as platform -- 平台
    ,invest_direction as invest_direction -- 投向
    ,final_invest as final_invest -- 最终投向类型
    ,five_class as five_class -- 五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）
    ,contract_version as contract_version -- 合同版本号（已审合同:0,送审合同:1,标准合同:2）
    ,extordid as extordid -- 外部交易号
    ,mitigation_freq as mitigation_freq -- 缓释频率
    ,manager_id as manager_id -- 实际管理人id
    ,manager_value as manager_value -- 实际管理人
    ,risk_proportion as risk_proportion -- 风险权重占比
    ,middle_classify as middle_classify -- 业务中类
    ,small_classify as small_classify -- 业务小类
    ,closing_start_date as closing_start_date -- 封闭开始日(对应开放类型为封闭型)
    ,closing_end_date as closing_end_date -- 封闭结束日(对应开放类型为封闭型)
    ,curr_open_break_date as curr_open_break_date -- 本周期开放终止日期
    ,curr_hold_end_date as curr_hold_end_date -- 本周期持有到期日期
    ,' ' as update_time2 -- 更新时间
    ,' ' as refer_code -- 参照代码
    ,' ' as is_cash_manage_type -- 是否现金管理类产品
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_equity_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

