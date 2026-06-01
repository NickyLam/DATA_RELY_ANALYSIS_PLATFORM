/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_gdpronsrsqssxx_body_djnsrxxkz
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxxkz_ex purge;
alter table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxxkz add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxxkz;

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxxkz_ex nologging
compress
as
select * from ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxxkz where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxxkz_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,djnsrxxkz -- 关联标签
    ,swdlrlxdh -- 税务代理人联系电话
    ,cwfzrsfzjhm -- 财务负责人身份证件号码
    ,zfjglxmc -- 总分机构类型名称
    ,gykglx_dm -- 总分机构类型名称
    ,scjydlxdh -- 生产经营地联系电话
    ,cwfzryddh -- 财务负责人移动电话
    ,zfjglx_dm -- 总分机构类型代码
    ,zzsqylxmc -- 增值税企业类型名称
    ,zcdyzbm -- 注册地邮政编码
    ,fddbryddh -- 法定代表人移动电话
    ,swdlrdzxx -- 税务代理人电子信箱
    ,ggrs -- 雇工人数
    ,cwfzrsfzjzlmc -- 财务负责人身份证件种类名称
    ,hjszd -- 户籍所在地
    ,cyrs -- 从业人数
    ,gykglxmc -- 国有控股类型名称
    ,cwfzrxm -- 财务负责人姓名
    ,bsrsfzjhm -- 办税人身份证件号码
    ,bzfsmc -- 办证方式名称
    ,gdgrs -- 固定工人数
    ,bsrsfzjzl_dm -- 办税人身份证件种类代码
    ,cwfzrdzxx -- 财务负责人电子信箱
    ,wjcyrs -- 外籍从业人数
    ,zzsqylx_dm -- 增值税企业类型代码
    ,tzze -- 投资总额
    ,cwfzrsfzjzl_dm -- 财务负责人身份证件种类代码
    ,scjydyzbm -- 生产经营地邮政编码
    ,jyfw -- 经营范围
    ,bsrdzxx -- 办税人电子信箱
    ,gjhdqsz_dm -- 国家或地区数字代码
    ,kjzdzzmc -- 会计制度（准则）名称
    ,zczb -- 注册资本
    ,cwfzrgddh -- 财务负责人固定电话
    ,bsryddh -- 办税人移动电话
    ,ygznsrlx_dm -- 营改增纳税人类型代码
    ,zzjglxmc -- 组织机构类型名称
    ,zzjglx_dm -- 组织机构类型代码
    ,bsrgddh -- 办税人固定电话
    ,ygznsrlxmc -- 营改增纳税人类型名称
    ,bsrxm -- 办税人姓名
    ,zzsjylb -- 增值税经营类别
    ,swdlrmc -- 税务代理人名称
    ,djxh -- 登记序号
    ,hsfs_dm -- 核算方式代码
    ,bzfs_dm -- 办证方式代码
    ,bsrsfzjzlmc -- 办税人身份证件种类名称
    ,gjhdqszmc -- 国家或地区数字名称
    ,zrrtzbl -- 自然人投资比例
    ,fddbrdzxx -- 法定代表人电子信箱
    ,hhrs -- 合伙人数
    ,wztzbl -- 外资投资比例
    ,kjzdzz_dm -- 会计制度（准则）代码
    ,zcdlxdh -- 注册地联系电话
    ,hsfsmc -- 核算方式名称
    ,gytzbl -- 国有投资比例
    ,fddbrgddh -- 法定代表人固定电话
    ,swdlrnsrsbh -- 税务代理人纳税人识别号
    ,genmonth -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,djnsrxxkz -- 关联标签
    ,swdlrlxdh -- 税务代理人联系电话
    ,cwfzrsfzjhm -- 财务负责人身份证件号码
    ,zfjglxmc -- 总分机构类型名称
    ,gykglx_dm -- 总分机构类型名称
    ,scjydlxdh -- 生产经营地联系电话
    ,cwfzryddh -- 财务负责人移动电话
    ,zfjglx_dm -- 总分机构类型代码
    ,zzsqylxmc -- 增值税企业类型名称
    ,zcdyzbm -- 注册地邮政编码
    ,fddbryddh -- 法定代表人移动电话
    ,swdlrdzxx -- 税务代理人电子信箱
    ,ggrs -- 雇工人数
    ,cwfzrsfzjzlmc -- 财务负责人身份证件种类名称
    ,hjszd -- 户籍所在地
    ,cyrs -- 从业人数
    ,gykglxmc -- 国有控股类型名称
    ,cwfzrxm -- 财务负责人姓名
    ,bsrsfzjhm -- 办税人身份证件号码
    ,bzfsmc -- 办证方式名称
    ,gdgrs -- 固定工人数
    ,bsrsfzjzl_dm -- 办税人身份证件种类代码
    ,cwfzrdzxx -- 财务负责人电子信箱
    ,wjcyrs -- 外籍从业人数
    ,zzsqylx_dm -- 增值税企业类型代码
    ,tzze -- 投资总额
    ,cwfzrsfzjzl_dm -- 财务负责人身份证件种类代码
    ,scjydyzbm -- 生产经营地邮政编码
    ,jyfw -- 经营范围
    ,bsrdzxx -- 办税人电子信箱
    ,gjhdqsz_dm -- 国家或地区数字代码
    ,kjzdzzmc -- 会计制度（准则）名称
    ,zczb -- 注册资本
    ,cwfzrgddh -- 财务负责人固定电话
    ,bsryddh -- 办税人移动电话
    ,ygznsrlx_dm -- 营改增纳税人类型代码
    ,zzjglxmc -- 组织机构类型名称
    ,zzjglx_dm -- 组织机构类型代码
    ,bsrgddh -- 办税人固定电话
    ,ygznsrlxmc -- 营改增纳税人类型名称
    ,bsrxm -- 办税人姓名
    ,zzsjylb -- 增值税经营类别
    ,swdlrmc -- 税务代理人名称
    ,djxh -- 登记序号
    ,hsfs_dm -- 核算方式代码
    ,bzfs_dm -- 办证方式代码
    ,bsrsfzjzlmc -- 办税人身份证件种类名称
    ,gjhdqszmc -- 国家或地区数字名称
    ,zrrtzbl -- 自然人投资比例
    ,fddbrdzxx -- 法定代表人电子信箱
    ,hhrs -- 合伙人数
    ,wztzbl -- 外资投资比例
    ,kjzdzz_dm -- 会计制度（准则）代码
    ,zcdlxdh -- 注册地联系电话
    ,hsfsmc -- 核算方式名称
    ,gytzbl -- 国有投资比例
    ,fddbrgddh -- 法定代表人固定电话
    ,swdlrnsrsbh -- 税务代理人纳税人识别号
    ,genmonth -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxxkz
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxxkz exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxxkz_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxxkz to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxxkz_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_gdpronsrsqssxx_body_djnsrxxkz',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);