/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wyd_credit_line
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

declare
     v_flag   number(10) :=0;
          
begin
	for tb in (select partition_name,table_name,substr(partition_name,3) as etl_dt 
	             from user_tab_partitions 
	            where table_name = upper('icms_wyd_credit_line_BAK_${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('icms_wyd_credit_line')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table icms_wyd_credit_line drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table icms_wyd_credit_line add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.icms_wyd_credit_line(
    datadt -- 数据日期
    ,limitno -- 额度编号
    ,custid -- 客户号
    ,custidtype -- 客户证件类型
    ,custidno -- 客户证件号码
    ,custname -- 客户名称
    ,ccycd -- 币种
    ,orgid -- 机构号
    ,circulflg -- 循环额度标志
    ,startdate -- 微众授信起始日期
    ,maturitydate -- 额度到期日期
    ,creditline -- 授信额度
    ,uncreditline -- 未动拨授信额度
    ,credittype -- 授信业务类型
    ,begindate -- 生效日期
    ,trandate -- 发生日期
    ,initdate -- 授信开始日期
    ,limitreportno -- 授信协议号
    ,status -- 协议状态
    ,freezeflag -- 冻结标志
    ,adjustdate -- 续期日期
    ,extenddate -- 更新时间
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,productid -- 产品编号
    ,classifyresult -- 废除五级分类
    ,balstatus -- 额度状态
    ,customerid -- 我行客户号
    ,inputid -- 行内客户经理编号
    ,baserialno -- 授信编号
    ,quotamod -- 模型核额额度
    ,hxcontractserialno -- 华兴额度合同编号
    ,hxproductid -- 华兴额度产品类型
    ,hxoperateorgid -- 华兴经办机构
    ,hxmanageorgid -- 华兴管理机构
    ,hxstartdate -- 华兴额度合同开始日期
    ,hxmaturity -- 华兴额度合同到期日期
    ,hxstatus -- 华兴额度合同状态
    ,hxiscycle -- 华兴额度循环标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    datadt -- 数据日期
    ,limitno -- 额度编号
    ,custid -- 客户号
    ,custidtype -- 客户证件类型
    ,custidno -- 客户证件号码
    ,custname -- 客户名称
    ,ccycd -- 币种
    ,orgid -- 机构号
    ,circulflg -- 循环额度标志
    ,startdate -- 微众授信起始日期
    ,maturitydate -- 额度到期日期
    ,creditline -- 授信额度
    ,uncreditline -- 未动拨授信额度
    ,credittype -- 授信业务类型
    ,begindate -- 生效日期
    ,trandate -- 发生日期
    ,initdate -- 授信开始日期
    ,limitreportno -- 授信协议号
    ,status -- 协议状态
    ,freezeflag -- 冻结标志
    ,adjustdate -- 续期日期
    ,extenddate -- 更新时间
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,productid -- 产品编号
    ,classifyresult -- 废除五级分类
    ,balstatus -- 额度状态
    ,customerid -- 我行客户号
    ,inputid -- 行内客户经理编号
    ,baserialno -- 授信编号
    ,quotamod -- 模型核额额度
    ,' ' as hxcontractserialno -- 华兴额度合同编号
    ,' ' as hxproductid -- 华兴额度产品类型
    ,' ' as hxoperateorgid -- 华兴经办机构
    ,' ' as hxmanageorgid -- 华兴管理机构
    ,to_date('00010101', 'yyyymmdd') as hxstartdate -- 华兴额度合同开始日期
    ,to_date('00010101', 'yyyymmdd') as hxmaturity -- 华兴额度合同到期日期
    ,' ' as hxstatus -- 华兴额度合同状态
    ,' ' as hxiscycle -- 华兴额度循环标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
from icms_wyd_credit_line_BAK_${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/