/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_info_wld
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
                       FROM icms_customer_info_wld_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('icms_customer_info_wld');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_customer_info_wld drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_customer_info_wld add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.icms_customer_info_wld(
            customerid -- 客户号
            ,customername -- 客户姓名
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,certstartdate -- 证件起始日
            ,certmaturity -- 证件到期日
            ,sex -- 性别
            ,occupation -- 职业
            ,nation -- 国籍
            ,address -- 地址
            ,telephone -- 联系电话
            ,isfarmer -- 农户标志
            ,isindividual -- 是否个体工商户
            ,isminbusiowner -- 是否小微企业主
            ,wldcustid -- 微粒贷客户号
            ,birthday -- 生日
            ,profcountry -- 是否永久居住
            ,residencycountrycd -- 永久居住地国家代码
            ,languageind -- 语言代码
            ,embname -- 拼音名
            ,surname -- 姓氏
            ,marrystate -- 婚姻状况
            ,homephone -- 家庭电话
            ,compphone -- 单位电话
            ,qualification -- 学历
            ,degree -- 学位
            ,resideaddr -- 户籍地址
            ,matecertp -- 配偶证件类型
            ,matecerno -- 配偶证件号码
            ,matename -- 配偶姓名
            ,matecorp -- 配偶工作单位
            ,matephone -- 配偶联系电话
            ,addr -- 居住地址
            ,residestate -- 居住状况
            ,compnm -- 工作单位
            ,compaddr -- 单位地址
            ,comptrade -- 行业
            ,business -- 职务
            ,teachpose -- 职称
            ,workdate -- 本单位工作起始年份
            ,expiredate -- 有效期
            ,entname -- 企业名称
            ,entcerttype -- 企业证件类型
            ,entcreditcode -- 统一社会信用代码
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,entregno -- 企业注册号
            ,entbusinessstatus -- 企业经营状态
            ,industrycode -- 行业代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            customerid -- 客户号
            ,customername -- 客户姓名
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,certstartdate -- 证件起始日
            ,certmaturity -- 证件到期日
            ,sex -- 性别
            ,occupation -- 职业
            ,nation -- 国籍
            ,address -- 地址
            ,telephone -- 联系电话
            ,isfarmer -- 农户标志
            ,isindividual -- 是否个体工商户
            ,isminbusiowner -- 是否小微企业主
            ,wldcustid -- 微粒贷客户号
            ,to_date('00010101','yyyymmdd') as birthday -- 生日
            ,' ' as profcountry -- 是否永久居住
            ,' ' as residencycountrycd -- 永久居住地国家代码
            ,' ' as languageind -- 语言代码
            ,' ' as embname -- 拼音名
            ,' ' as surname -- 姓氏
            ,' ' as marrystate -- 婚姻状况
            ,' ' as homephone -- 家庭电话
            ,' ' as compphone -- 单位电话
            ,' ' as qualification -- 学历
            ,' ' as degree -- 学位
            ,' ' as resideaddr -- 户籍地址
            ,' ' as matecertp -- 配偶证件类型
            ,' ' as matecerno -- 配偶证件号码
            ,' ' as matename -- 配偶姓名
            ,' ' as matecorp -- 配偶工作单位
            ,' ' as matephone -- 配偶联系电话
            ,' ' as addr -- 居住地址
            ,' ' as residestate -- 居住状况
            ,' ' as compnm -- 工作单位
            ,' ' as compaddr -- 单位地址
            ,' ' as comptrade -- 行业
            ,' ' as business -- 职务
            ,' ' as teachpose -- 职称
            ,' ' as workdate -- 本单位工作起始年份
            ,to_date('00010101','yyyymmdd') as expiredate -- 有效期
            ,' ' as entname -- 企业名称
            ,' ' as entcerttype -- 企业证件类型
            ,' ' as entcreditcode -- 统一社会信用代码
            ,to_date('00010101','yyyymmdd') as inputdate -- 登记日期
            ,to_date('00010101','yyyymmdd') as updatedate -- 更新日期
            ,' ' as entregno -- 企业注册号
            ,' ' as entbusinessstatus -- 企业经营状态
            ,' ' as industrycode -- 行业代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from icms_customer_info_wld_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
