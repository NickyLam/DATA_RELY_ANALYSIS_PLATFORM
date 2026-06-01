/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_HQD_IQP_LOAN_PRIOR_ret1
CreateDate: 20240712_月度版本
Logs:
     SUNDEXIN 新建脚本 
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
                       FROM ICMS_HQD_IQP_LOAN_PRIOR_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_HQD_IQP_LOAN_PRIOR');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_HQD_IQP_LOAN_PRIOR drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_HQD_IQP_LOAN_PRIOR add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_HQD_IQP_LOAN_PRIOR(
            serialno -- 业务流水号
            ,applyno -- 信贷申请流水号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,cusid -- 法人代表人客户号
            ,cusname -- 法人代表人姓名
            ,finalapplyamount -- 初审审批额度(元)
            ,inputdate -- 初审申请日期
            ,approvestatus -- 审批状态
            ,inputid -- 客户经理编号
            ,belongdept -- 所属分行名称
            ,appchannel -- 接入渠道
            ,birth -- 法人代表人出生日期
            ,certtype -- 法人代表人证件类型
            ,certno -- 法人代表人证件号码
            ,gender -- 法人代表人性别
            ,phone -- 法人代表人联系号码
            ,issdate -- 签发日期
            ,expirydate -- 借款人证件到期日
            ,dwellprovincecode -- 居住地址所在省份编码
            ,dwellcitycode -- 居住地址所在城市编码
            ,dwellareacode -- 居住地址所在区域编码
            ,dwelladdress -- 居住详细地址
            ,career -- 职业
            ,nationality -- 国籍
            ,entname -- 企业名称
            ,creditcode -- 统一社会信用代码
            ,taxno -- 纳税人识别号
            ,taxflag -- 税务查询标志(深圳/广东税务局)
            ,applyflag -- 是否授权
            ,taxapplyno -- 税务查询授权流水号
            ,productchannel -- 产品分类标志
            ,attribute1 -- 备用字段1
            ,attribute2 -- 备用字段2
            ,attribute3 -- 备用字段3
            ,attribute4 -- 备用字段4
            ,attribute5 -- 备用字段5
            ,sysid -- 系统来源
            ,qryopertp -- 查询操作申请类型
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,warninginfo -- 预警信息
            ,failreason -- 拒绝原因
            ,businessscope -- 经营范围
            ,businessvalidity -- 经营有效期（区间）
            ,registeredaddress -- 注册地址
            ,issmallent -- 是否小微企业
            ,inputorgid -- 登记机构
            ,nextyearincome -- 预测次年销售收入
            ,otherincome -- 其他渠道提供的营运资金
            ,informflag -- 是否通知
            ,applyenddate -- 初审结束日期
            ,registerdate -- 企业注册时间
            ,entmouthprice -- 每月租金金额
            ,entmouth -- 企业入驻月份数
            ,scale -- 企业规模
            ,proceeds -- 经营收入
            ,autoscore -- 评分分值
            ,gongancheckresult -- 公安联网核查结果
            ,mybankaffiliateflag -- 是否我行关联人
            ,zhengxincheckresult -- 征信校验结果
            ,baserialno -- 授信表流水号
            ,status -- 初审状态
            ,tradecode -- 行业类型
            ,empcountyear -- 从业人数
            ,tatalasset -- 资产合计
            ,enreportimage -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 业务流水号
            ,applyno -- 信贷申请流水号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,cusid -- 法人代表人客户号
            ,cusname -- 法人代表人姓名
            ,finalapplyamount -- 初审审批额度(元)
            ,inputdate -- 初审申请日期
            ,approvestatus -- 审批状态
            ,inputid -- 客户经理编号
            ,belongdept -- 所属分行名称
            ,appchannel -- 接入渠道
            ,birth -- 法人代表人出生日期
            ,certtype -- 法人代表人证件类型
            ,certno -- 法人代表人证件号码
            ,gender -- 法人代表人性别
            ,phone -- 法人代表人联系号码
            ,issdate -- 签发日期
            ,expirydate -- 借款人证件到期日
            ,dwellprovincecode -- 居住地址所在省份编码
            ,dwellcitycode -- 居住地址所在城市编码
            ,dwellareacode -- 居住地址所在区域编码
            ,dwelladdress -- 居住详细地址
            ,career -- 职业
            ,nationality -- 国籍
            ,entname -- 企业名称
            ,creditcode -- 统一社会信用代码
            ,taxno -- 纳税人识别号
            ,taxflag -- 税务查询标志(深圳/广东税务局)
            ,applyflag -- 是否授权
            ,taxapplyno -- 税务查询授权流水号
            ,productchannel -- 产品分类标志
            ,attribute1 -- 备用字段1
            ,attribute2 -- 备用字段2
            ,attribute3 -- 备用字段3
            ,attribute4 -- 备用字段4
            ,attribute5 -- 备用字段5
            ,sysid -- 系统来源
            ,qryopertp -- 查询操作申请类型
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,warninginfo -- 预警信息
            ,failreason -- 拒绝原因
            ,businessscope -- 经营范围
            ,businessvalidity -- 经营有效期（区间）
            ,registeredaddress -- 注册地址
            ,issmallent -- 是否小微企业
            ,inputorgid -- 登记机构
            ,nextyearincome -- 预测次年销售收入
            ,otherincome -- 其他渠道提供的营运资金
            ,informflag -- 是否通知
            ,applyenddate -- 初审结束日期
            ,registerdate -- 企业注册时间
            ,entmouthprice -- 每月租金金额
            ,entmouth -- 企业入驻月份数
            ,scale -- 企业规模
            ,proceeds -- 经营收入
            ,autoscore -- 评分分值
            ,gongancheckresult -- 公安联网核查结果
            ,mybankaffiliateflag -- 是否我行关联人
            ,zhengxincheckresult -- 征信校验结果
            ,baserialno -- 授信表流水号
            ,status -- 初审状态
            ,tradecode -- 行业类型
            ,empcountyear -- 从业人数
            ,tatalasset -- 资产合计
            ,' ' AS enreportimage -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_HQD_IQP_LOAN_PRIOR_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
