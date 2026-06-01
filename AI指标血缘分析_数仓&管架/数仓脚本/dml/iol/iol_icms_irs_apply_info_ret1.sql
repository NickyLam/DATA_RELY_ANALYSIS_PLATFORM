/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_irs_apply_info
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
                       FROM icms_irs_apply_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('icms_irs_apply_info');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_irs_apply_info drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_irs_apply_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.icms_irs_apply_info(
            adjustlasttime -- 最后特例调整时间
            ,adjustlevel -- 特例调整等级
            ,applyid -- 申请id
            ,applytype -- 流程申请类型
            ,approvestatus -- 审批状态
            ,auditflag -- 使用财报是否审计
            ,balance -- 业务余额
            ,creditapplyid -- 授信申请Id(授信途中发起评级才会有)
            ,creditsync -- 是否同步授信流程 1是0否 授信发起的评级流程如果需要同步则为1，如果评级流程单独触发过退回则不再同步
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,customertype -- 客户类型
            ,datasource -- 数据来源 1.申请2.跑批3.老评级
            ,entscale -- 企业规模
            ,enttype -- 企业类型 参考字典IrsEntType
            ,finallevel -- 确认等级
            ,hightech -- 是否高新技术企业
            ,industrytype -- 国标行业
            ,inputdate -- 创建时间
            ,inputorgid -- 创建人机构
            ,inputorgname -- 创建机构名称
            ,inputuserid -- 创建人id
            ,inputusername -- 创建人名称
            ,lastapplyid -- 上期申请Id
            ,lastreporttime -- 最新年报期次
            ,modelcode -- 模型编码
            ,modelname -- 模型名称
            ,needreport -- 是否需要财报
            ,occurtype -- 评级发生类型 1.评级认定2.评级更新
            ,originlevel -- 初始机评等级
            ,overthrowlevel -- 推翻等级
            ,overthrowreason -- 推翻原因
            ,phaseopinion -- 签署意见
            ,pusherrorinfo -- 同盾推动异常信息，如果推送成功则为空
            ,ratedelaydate -- 本次延期期限
            ,ratedelaymonth -- 申请延期时长（月）
            ,ratedelayreason -- 延期原因
            ,rateobjtype -- 评级对象类型
            ,realestate -- 是否房地产开发公司
            ,remark -- 备注
            ,reportno -- 使用财报编号
            ,reportscope -- 使用财报的口径
            ,reporttime -- 评级期次 使用财报则为财报期次，否则为T-1年度
            ,reporttypeno -- 财报类型
            ,savelimittimes -- 保存限制次数
            ,savetimes -- 已经保存次数 防止客户经理多次保存探索规则引擎计算规律
            ,setupdate -- 成立日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            adjustlasttime -- 最后特例调整时间
            ,adjustlevel -- 特例调整等级
            ,applyid -- 申请id
            ,applytype -- 流程申请类型
            ,approvestatus -- 审批状态
            ,auditflag -- 使用财报是否审计
            ,balance -- 业务余额
            ,creditapplyid -- 授信申请Id(授信途中发起评级才会有)
            ,creditsync -- 是否同步授信流程 1是0否 授信发起的评级流程如果需要同步则为1，如果评级流程单独触发过退回则不再同步
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,customertype -- 客户类型
            ,datasource -- 数据来源 1.申请2.跑批3.老评级
            ,entscale -- 企业规模
            ,enttype -- 企业类型 参考字典IrsEntType
            ,finallevel -- 确认等级
            ,hightech -- 是否高新技术企业
            ,industrytype -- 国标行业
            ,inputdate -- 创建时间
            ,inputorgid -- 创建人机构
            ,inputorgname -- 创建机构名称
            ,inputuserid -- 创建人id
            ,inputusername -- 创建人名称
            ,lastapplyid -- 上期申请Id
            ,lastreporttime -- 最新年报期次
            ,modelcode -- 模型编码
            ,modelname -- 模型名称
            ,needreport -- 是否需要财报
            ,occurtype -- 评级发生类型 1.评级认定2.评级更新
            ,originlevel -- 初始机评等级
            ,overthrowlevel -- 推翻等级
            ,overthrowreason -- 推翻原因
            ,phaseopinion -- 签署意见
            ,pusherrorinfo -- 同盾推动异常信息，如果推送成功则为空
            ,ratedelaydate -- 本次延期期限
            ,ratedelaymonth -- 申请延期时长（月）
            ,ratedelayreason -- 延期原因
            ,rateobjtype -- 评级对象类型
            ,realestate -- 是否房地产开发公司
            ,remark -- 备注
            ,reportno -- 使用财报编号
            ,reportscope -- 使用财报的口径
            ,reporttime -- 评级期次 使用财报则为财报期次，否则为T-1年度
            ,reporttypeno -- 财报类型
            ,savelimittimes -- 保存限制次数
            ,savetimes -- 已经保存次数 防止客户经理多次保存探索规则引擎计算规律
            ,setupdate -- 成立日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_irs_apply_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
