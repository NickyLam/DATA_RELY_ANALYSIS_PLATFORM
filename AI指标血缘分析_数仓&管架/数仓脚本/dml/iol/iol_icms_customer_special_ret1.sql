/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_CUSTOMER_SPECIAL_ret1
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
                       FROM ICMS_CUSTOMER_SPECIAL_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_CUSTOMER_SPECIAL');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_CUSTOMER_SPECIAL drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_CUSTOMER_SPECIAL add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_CUSTOMER_SPECIAL(
            serialno -- 流水号
            ,email -- 邮箱
            ,controltype -- 控制方式
            ,inputdate -- 登记日期
            ,certtype -- 证件类型
            ,nationcode -- 证件国别
            ,companytel -- 单位电话
            ,relationship -- 关系
            ,shareratio -- 持有本行股份占比
            ,inputuserid -- 登记人编号
            ,customername -- 客户名称
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,source -- 来源描述
            ,content -- 黑名单内容
            ,begindate -- 开始日期
            ,listingplace -- 上市地点
            ,jobtitle -- 职称
            ,platformlevel -- 平台等级
            ,birthday -- 出生日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,relativecustname -- 关联客户名称
            ,educationdegree -- 最高学位
            ,certid -- 证件号码
            ,enddate -- 结束时间
            ,updateuserid -- 更新人编号
            ,inputtype -- 入库类型
            ,corporgid -- 法人机构编号
            ,specialcustomersubtype -- 名单类别-子类
            ,sex -- 性别
            ,inliststatus -- 是否有效
            ,relativecustid -- 关联客户编号
            ,shares -- 持有本行股份数
            ,inputorgid -- 登记机构编号
            ,actualassert -- 实缴资本
            ,updateorgid -- 更新机构编号
            ,approvestatus -- 审批状态
            ,provider -- 名单来源
            ,specialcustomertype -- 名单类别
            ,inlistreason -- 列入原因
            ,industrytype -- 国际行业分类国际行业分类型
            ,reason -- 入库原因
            ,customerid -- 客户编号
            ,mobiletel -- 手机号码
            ,addapprovestatus -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 流水号
            ,email -- 邮箱
            ,controltype -- 控制方式
            ,inputdate -- 登记日期
            ,certtype -- 证件类型
            ,nationcode -- 证件国别
            ,companytel -- 单位电话
            ,relationship -- 关系
            ,shareratio -- 持有本行股份占比
            ,inputuserid -- 登记人编号
            ,customername -- 客户名称
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,source -- 来源描述
            ,content -- 黑名单内容
            ,begindate -- 开始日期
            ,listingplace -- 上市地点
            ,jobtitle -- 职称
            ,platformlevel -- 平台等级
            ,birthday -- 出生日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,relativecustname -- 关联客户名称
            ,educationdegree -- 最高学位
            ,certid -- 证件号码
            ,enddate -- 结束时间
            ,updateuserid -- 更新人编号
            ,inputtype -- 入库类型
            ,corporgid -- 法人机构编号
            ,specialcustomersubtype -- 名单类别-子类
            ,sex -- 性别
            ,inliststatus -- 是否有效
            ,relativecustid -- 关联客户编号
            ,shares -- 持有本行股份数
            ,inputorgid -- 登记机构编号
            ,actualassert -- 实缴资本
            ,updateorgid -- 更新机构编号
            ,approvestatus -- 审批状态
            ,provider -- 名单来源
            ,specialcustomertype -- 名单类别
            ,inlistreason -- 列入原因
            ,industrytype -- 国际行业分类国际行业分类型
            ,reason -- 入库原因
            ,customerid -- 客户编号
            ,mobiletel -- 手机号码
            ,' ' AS addapprovestatus -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_CUSTOMER_SPECIAL_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
