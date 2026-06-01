/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_chinamutualfunddescription
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
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
                       FROM wind_chinamutualfunddescription_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('wind_chinamutualfunddescription');
  
  if v_var <> 0 then 
    execute immediate 'alter table wind_chinamutualfunddescription drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table wind_chinamutualfunddescription add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.wind_chinamutualfunddescription(
        object_id -- 对象ID
        ,f_info_windcode -- Wind代码
        ,f_info_front_code -- 前端代码
        ,f_info_backend_code -- 后端代码
        ,f_info_fullname -- 名称
        ,f_info_name -- 简称
        ,f_info_corp_fundmanagementcomp -- 管理人
        ,f_info_custodianbank -- 托管人
        ,f_info_firstinvesttype -- 投资类型
        ,f_info_setupdate -- 成立日期
        ,f_info_maturitydate -- 到期日期
        ,f_issue_totalunit -- 发行份额
        ,f_info_managementfeeratio -- 管理费
        ,f_info_custodianfeeratio -- 托管费
        ,crny_code -- 货币代码
        ,f_info_ptmyear -- 存续期
        ,f_issue_oef_startdateinst -- 机构投资者认购起始日
        ,f_issue_oef_dnddateinst -- 机构投资者认购终止日
        ,f_info_parvalue -- 面值
        ,f_info_trusttype -- 信托类别
        ,f_info_trustee -- 受托人
        ,f_pchredm_pchstartdate -- 日常申购起始日
        ,f_info_redmstartdate -- 日常赎回起始日
        ,f_info_minbuyamount -- 起点金额
        ,f_info_expectedrateofreturn -- 预期收益率
        ,f_info_issuingplace -- 发行地
        ,f_info_benchmark -- 业绩比较基准
        ,f_info_status -- 存续状态
        ,f_info_restrictedornot -- 限定类型
        ,f_info_structuredornot -- 是否结构化产品
        ,f_info_exchmarket -- 交易所
        ,f_info_firstinveststyle -- 投资风格
        ,f_info_issuedate -- 发行日期
        ,f_info_type -- 基金类型
        ,f_info_isinitial -- 是否为初始基金
        ,f_info_pinyin -- 简称拼音
        ,f_info_investscope -- 投资范围
        ,f_info_investobject -- 投资目标
        ,f_info_investconception -- 投资理念
        ,f_info_decision_basis -- 决策依据
        ,is_indexfund -- 是否指数基金
        ,f_info_delistdate -- 退市日期
        ,f_info_corp_fundmanagementid -- 基金管理人ID
        ,f_info_custodianbankid -- 托管人id
        ,max_num_holder -- 单一投资者持有份额上限(亿份)
        ,max_num_coltarget -- 封闭期目标募集数量上限(亿份)
        ,investstrategy -- 投资策略
        ,risk_return -- 基金风险收益特征
        ,f_pchredm_pchminamt -- 每次最低申购金额(场外)(万元)
        ,f_pchredm_pchminamt_ex -- 每次最低申购金额(场内) (万元)
        ,f_info_listdate -- 上市时间
        ,f_info_anndate -- 公告日期
        ,f_closed_operation_period -- 封闭运作期
        ,f_closed_operation_interval -- 封闭运作期满开放日间隔
        ,f_info_registrant -- 基金注册与过户登记人ID
        ,f_personal_startdateind -- 个人投资者认购起始日
        ,f_personal_enddateind -- 个人投资者认购终止日
        ,f_info_fund_id -- 基金品种ID
        ,f_personal_subtype -- 个人投资者认购方式
        ,close_institu_subtype -- 封闭期机构投资者认购方式
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
            object_id -- 对象ID
        ,f_info_windcode -- Wind代码
        ,f_info_front_code -- 前端代码
        ,f_info_backend_code -- 后端代码
        ,f_info_fullname -- 名称
        ,f_info_name -- 简称
        ,f_info_corp_fundmanagementcomp -- 管理人
        ,f_info_custodianbank -- 托管人
        ,f_info_firstinvesttype -- 投资类型
        ,f_info_setupdate -- 成立日期
        ,f_info_maturitydate -- 到期日期
        ,f_issue_totalunit -- 发行份额
        ,f_info_managementfeeratio -- 管理费
        ,f_info_custodianfeeratio -- 托管费
        ,crny_code -- 货币代码
        ,f_info_ptmyear -- 存续期
        ,f_issue_oef_startdateinst -- 机构投资者认购起始日
        ,f_issue_oef_dnddateinst -- 机构投资者认购终止日
        ,f_info_parvalue -- 面值
        ,f_info_trusttype -- 信托类别
        ,f_info_trustee -- 受托人
        ,f_pchredm_pchstartdate -- 日常申购起始日
        ,f_info_redmstartdate -- 日常赎回起始日
        ,f_info_minbuyamount -- 起点金额
        ,f_info_expectedrateofreturn -- 预期收益率
        ,f_info_issuingplace -- 发行地
        ,f_info_benchmark -- 业绩比较基准
        ,f_info_status -- 存续状态
        ,f_info_restrictedornot -- 限定类型
        ,f_info_structuredornot -- 是否结构化产品
        ,f_info_exchmarket -- 交易所
        ,f_info_firstinveststyle -- 投资风格
        ,f_info_issuedate -- 发行日期
        ,f_info_type -- 基金类型
        ,f_info_isinitial -- 是否为初始基金
        ,f_info_pinyin -- 简称拼音
        ,f_info_investscope -- 投资范围
        ,f_info_investobject -- 投资目标
        ,f_info_investconception -- 投资理念
        ,f_info_decision_basis -- 决策依据
        ,is_indexfund -- 是否指数基金
        ,f_info_delistdate -- 退市日期
        ,f_info_corp_fundmanagementid -- 基金管理人ID
        ,f_info_custodianbankid -- 托管人id
        ,max_num_holder -- 单一投资者持有份额上限(亿份)
        ,max_num_coltarget -- 封闭期目标募集数量上限(亿份)
        ,substr(investstrategy,1,1300) -- 投资策略
        ,substr(risk_return,1,1300) -- 基金风险收益特征
        ,f_pchredm_pchminamt -- 每次最低申购金额(场外)(万元)
        ,f_pchredm_pchminamt_ex -- 每次最低申购金额(场内) (万元)
        ,f_info_listdate -- 上市时间
        ,f_info_anndate -- 公告日期
        ,f_closed_operation_period -- 封闭运作期
        ,f_closed_operation_interval -- 封闭运作期满开放日间隔
        ,f_info_registrant -- 基金注册与过户登记人ID
        ,f_personal_startdateind -- 个人投资者认购起始日
        ,f_personal_enddateind -- 个人投资者认购终止日
        ,f_info_fund_id -- 基金品种ID
        ,f_personal_subtype -- 个人投资者认购方式
        ,close_institu_subtype -- 封闭期机构投资者认购方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.wind_chinamutualfunddescription_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
