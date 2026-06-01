/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_code_library
CreateDate: 20250527
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_code_library drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_code_library add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_code_library (
etl_dt  --数据日期
,attribute6  --属性6
,inputuser  --登记人
,attribute8  --属性8
,updatetime  --
,attribute3  --属性3
,helptext  --帮助
,attribute9  --屬性9
,itemdescribe  --项目描述
,updatedate  --更新日期
,remark  --备注
,parentitemno  --关联上级编号
,inputorg  --登记机构
,attribute1  --属性1
,attribute7  --属性7
,inputdate  --登记日期
,attribute5  --属性5
,attribute4  --属性4
,codeno  --代码编号
,itemno  --代码项编号
,relativecode  --关联代码
,sortno  --排序号
,isinuse  --是否使用
,mappingcode  --映射到其他系统的码值
,updateuser  --更新人
,updateorg  --更新机构
,bankno  --征信代码
,itemattribute  --项目属性
,itemname  --代码项名称
,attribute2  --属性2
,inputtime  --

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.attribute6,chr(13),''),chr(10),'') as attribute6 --属性6
,replace(replace(t1.inputuser,chr(13),''),chr(10),'') as inputuser --登记人
,replace(replace(t1.attribute8,chr(13),''),chr(10),'') as attribute8 --属性8
,replace(replace(t1.updatetime,chr(13),''),chr(10),'') as updatetime --
,replace(replace(t1.attribute3,chr(13),''),chr(10),'') as attribute3 --属性3
,replace(replace(t1.helptext,chr(13),''),chr(10),'') as helptext --帮助
,replace(replace(t1.attribute9,chr(13),''),chr(10),'') as attribute9 --屬性9
,replace(replace(t1.itemdescribe,chr(13),''),chr(10),'') as itemdescribe --项目描述
,t1.updatedate as updatedate --更新日期
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,replace(replace(t1.parentitemno,chr(13),''),chr(10),'') as parentitemno --关联上级编号
,replace(replace(t1.inputorg,chr(13),''),chr(10),'') as inputorg --登记机构
,replace(replace(t1.attribute1,chr(13),''),chr(10),'') as attribute1 --属性1
,replace(replace(t1.attribute7,chr(13),''),chr(10),'') as attribute7 --属性7
,t1.inputdate as inputdate --登记日期
,replace(replace(t1.attribute5,chr(13),''),chr(10),'') as attribute5 --属性5
,replace(replace(t1.attribute4,chr(13),''),chr(10),'') as attribute4 --属性4
,replace(replace(t1.codeno,chr(13),''),chr(10),'') as codeno --代码编号
,replace(replace(t1.itemno,chr(13),''),chr(10),'') as itemno --代码项编号
,replace(replace(t1.relativecode,chr(13),''),chr(10),'') as relativecode --关联代码
,replace(replace(t1.sortno,chr(13),''),chr(10),'') as sortno --排序号
,replace(replace(t1.isinuse,chr(13),''),chr(10),'') as isinuse --是否使用
,replace(replace(t1.mappingcode,chr(13),''),chr(10),'') as mappingcode --映射到其他系统的码值
,replace(replace(t1.updateuser,chr(13),''),chr(10),'') as updateuser --更新人
,replace(replace(t1.updateorg,chr(13),''),chr(10),'') as updateorg --更新机构
,replace(replace(t1.bankno,chr(13),''),chr(10),'') as bankno --征信代码
,replace(replace(t1.itemattribute,chr(13),''),chr(10),'') as itemattribute --项目属性
,replace(replace(t1.itemname,chr(13),''),chr(10),'') as itemname --代码项名称
,replace(replace(t1.attribute2,chr(13),''),chr(10),'') as attribute2 --属性2
,replace(replace(t1.inputtime,chr(13),''),chr(10),'') as inputtime --
from ${iol_schema}.icms_code_library t1    --代码表代码库
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_code_library',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
