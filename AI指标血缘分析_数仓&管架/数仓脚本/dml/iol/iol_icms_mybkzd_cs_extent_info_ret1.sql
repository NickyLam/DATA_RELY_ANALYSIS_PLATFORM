/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybkzd_cs_extent_info
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
                       FROM icms_mybkzd_cs_extent_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('icms_mybkzd_cs_extent_info');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_mybkzd_cs_extent_info drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_mybkzd_cs_extent_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.icms_mybkzd_cs_extent_info(
            serialno -- 流水号
            ,applyno -- 蚂蚁申请编号
            ,mobile -- 手机号码
            ,address -- 地址信息
            ,prov -- 省份
            ,city -- 城市
            ,area -- 地区
            ,certvalidenddate -- 证件有效期
            ,busdatareqdate -- 采集时间
            ,businfoexistflag -- 是否存有效商信息
            ,notexistreason -- 无有效工商信息原因
            ,companyinfoname -- 公司名
            ,companyinfolawer -- 法定代表
            ,registerno -- 工商注册号
            ,registerdate -- 注册时间
            ,registeraddress -- 注册地址
            ,registeraddressareacode -- 注册地址行政区编号
            ,registeraddressarea -- 注册地省市区
            ,registerfund -- 注册资本(万元)
            ,fundcurrency -- 币种
            ,tradecode -- 行业代码
            ,managerange -- 经营范围
            ,orgcode -- 组织机构号
            ,registerdepartment -- 注册工商局
            ,statusid -- 经营状态
            ,statusdesc -- 经营状态描述
            ,lastcheckyear -- 最后年检年度
            ,managebegindate -- 经营开始时间
            ,manageenddate -- 经营结束时间
            ,opendate -- 开业时间
            ,companytype -- 公司类型
            ,economictype -- 公司经济类型
            ,targetjyflag1 -- 客群经营标签（经营场景)
            ,industryname -- 客群主营行业
            ,certvalidstartdate -- 证件有效期起始日
            ,sex -- 性别
            ,indivocc -- 职业
            ,nationality -- 国籍
            ,businessscene -- 业务场景
            ,businesstag -- 业务标识
            ,pushreason -- 客群区分标识
            ,custverifytype -- 核身方式
            ,custverifyresult -- 核身结果
            ,custverifytime -- 核身通过时间
            ,customertag -- 客群标
            ,employee_id -- 推广者员工号
            ,nation -- 民族
            ,company_info_org_code -- 统一社会信用代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 流水号
            ,applyno -- 蚂蚁申请编号
            ,mobile -- 手机号码
            ,address -- 地址信息
            ,prov -- 省份
            ,city -- 城市
            ,area -- 地区
            ,certvalidenddate -- 证件有效期
            ,busdatareqdate -- 采集时间
            ,businfoexistflag -- 是否存有效商信息
            ,notexistreason -- 无有效工商信息原因
            ,companyinfoname -- 公司名
            ,companyinfolawer -- 法定代表
            ,registerno -- 工商注册号
            ,registerdate -- 注册时间
            ,registeraddress -- 注册地址
            ,registeraddressareacode -- 注册地址行政区编号
            ,registeraddressarea -- 注册地省市区
            ,registerfund -- 注册资本(万元)
            ,fundcurrency -- 币种
            ,tradecode -- 行业代码
            ,substr(managerange,1,1300) -- 经营范围
            ,orgcode -- 组织机构号
            ,registerdepartment -- 注册工商局
            ,statusid -- 经营状态
            ,statusdesc -- 经营状态描述
            ,lastcheckyear -- 最后年检年度
            ,managebegindate -- 经营开始时间
            ,manageenddate -- 经营结束时间
            ,opendate -- 开业时间
            ,companytype -- 公司类型
            ,economictype -- 公司经济类型
            ,targetjyflag1 -- 客群经营标签（经营场景)
            ,industryname -- 客群主营行业
            ,certvalidstartdate -- 证件有效期起始日
            ,sex -- 性别
            ,indivocc -- 职业
            ,nationality -- 国籍
            ,businessscene -- 业务场景
            ,businesstag -- 业务标识
            ,pushreason -- 客群区分标识
            ,custverifytype -- 核身方式
            ,custverifyresult -- 核身结果
            ,custverifytime -- 核身通过时间
            ,customertag -- 客群标
            ,employee_id -- 推广者员工号
            ,nation -- 民族
            ,company_info_org_code -- 统一社会信用代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_mybkzd_cs_extent_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
