/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_CUSTOMER_SHIP_FAMILY_ret1
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
                       FROM ICMS_CUSTOMER_SHIP_FAMILY_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_CUSTOMER_SHIP_FAMILY');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_CUSTOMER_SHIP_FAMILY drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_CUSTOMER_SHIP_FAMILY add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_CUSTOMER_SHIP_FAMILY(
            serialno -- 流水号
            ,updateorgid -- 更新机构
            ,birthday -- 出生日期
            ,workaddress -- 公司地址
            ,corporgid -- 法人机构编号
            ,inputorgid -- 登记机构
            ,areacode -- 区号
            ,remark -- 备注
            ,customerid -- 客户编号
            ,relationship -- 家族关系
            ,worktel -- 家庭成员所在单位电话
            ,maincustomerid -- 主客户号
            ,updateuserid -- 更新人
            ,customername -- 家族成员姓名
            ,address -- 地址
            ,eduexperience -- 最高学历
            ,monthincome -- 月收入
            ,certid -- 证件号码
            ,countryzone -- 联系人座机
            ,indtel -- 联系电话
            ,certtype -- 证件类型
            ,inputuserid -- 登记人
            ,workstartdate -- 参加工作年份
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,entloancardno -- 家族成员所在企业贷款卡编号
            ,entname -- 家族成员所在企业名称
            ,unitcountry -- 单位所在地编码
            ,unitcountryname -- 所在地名称
            ,migtoldvalue -- 备份原字段值
            ,certstartdate -- 
            ,certduedate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 流水号
            ,updateorgid -- 更新机构
            ,birthday -- 出生日期
            ,workaddress -- 公司地址
            ,corporgid -- 法人机构编号
            ,inputorgid -- 登记机构
            ,areacode -- 区号
            ,remark -- 备注
            ,customerid -- 客户编号
            ,relationship -- 家族关系
            ,worktel -- 家庭成员所在单位电话
            ,maincustomerid -- 主客户号
            ,updateuserid -- 更新人
            ,customername -- 家族成员姓名
            ,address -- 地址
            ,eduexperience -- 最高学历
            ,monthincome -- 月收入
            ,certid -- 证件号码
            ,countryzone -- 联系人座机
            ,indtel -- 联系电话
            ,certtype -- 证件类型
            ,inputuserid -- 登记人
            ,workstartdate -- 参加工作年份
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,entloancardno -- 家族成员所在企业贷款卡编号
            ,entname -- 家族成员所在企业名称
            ,unitcountry -- 单位所在地编码
            ,unitcountryname -- 所在地名称
            ,migtoldvalue -- 备份原字段值
            ,to_date('00010101','yyyymmdd')  AS certstartdate -- 
            ,to_date('00010101','yyyymmdd')  AS certduedate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_CUSTOMER_SHIP_FAMILY_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
