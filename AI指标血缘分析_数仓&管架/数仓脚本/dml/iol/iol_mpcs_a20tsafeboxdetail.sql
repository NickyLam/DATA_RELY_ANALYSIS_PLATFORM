/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a20tsafeboxdetail
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
drop table ${iol_schema}.mpcs_a20tsafeboxdetail_ex purge;
alter table ${iol_schema}.mpcs_a20tsafeboxdetail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a20tsafeboxdetail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a20tsafeboxdetail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a20tsafeboxdetail where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a20tsafeboxdetail_ex(
    insertdt -- 登记日期
    ,inserttm -- 登记时间
    ,operdt -- 操作日期
    ,opername -- 操作人
    ,rentboxdate -- 租箱日期
    ,rentboxenddt -- 租箱到期日
    ,safebox -- 保管箱编号
    ,openmode -- 开箱方式 11：印鉴；12：钥匙；13：密码；14：指纹；15：其他。若复合验证开箱方式为：12+13
    ,opendate -- 开箱日期
    ,openpsnflag -- 开箱人公私标识 11：个人；12：单位（指使用人）
    ,openpsnname -- 开箱人姓名/名称
    ,openpsnidtp -- 开箱人身份证件/证明文件类型
    ,openpsnidno -- 开箱人身份证件/证明文件号码
    ,openpsniddt -- 开箱人身份证件/证明文件有效期
    ,openpsnid -- 开箱人身份 11：主租人；12：联名人；13：被授权人
    ,brchno -- 保管箱所在的网点代码
    ,userflag -- 保管箱实际使用人公私标识 11：个人；12：单位（指使用人）
    ,username -- 保管箱实际使用人姓名/名称
    ,useridtp -- 保管箱实际使用人身份证件/证明文件类型
    ,useridno -- 保管箱实际使用人身份证件/证明文件号码
    ,useriddt -- 保管箱实际使用人身份证件/证明文件有效期
    ,usercustno -- 实际使用人客户号
    ,filename -- 文件名
    ,lineno -- 行号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    insertdt -- 登记日期
    ,inserttm -- 登记时间
    ,operdt -- 操作日期
    ,opername -- 操作人
    ,rentboxdate -- 租箱日期
    ,rentboxenddt -- 租箱到期日
    ,safebox -- 保管箱编号
    ,openmode -- 开箱方式 11：印鉴；12：钥匙；13：密码；14：指纹；15：其他。若复合验证开箱方式为：12+13
    ,opendate -- 开箱日期
    ,openpsnflag -- 开箱人公私标识 11：个人；12：单位（指使用人）
    ,openpsnname -- 开箱人姓名/名称
    ,openpsnidtp -- 开箱人身份证件/证明文件类型
    ,openpsnidno -- 开箱人身份证件/证明文件号码
    ,openpsniddt -- 开箱人身份证件/证明文件有效期
    ,openpsnid -- 开箱人身份 11：主租人；12：联名人；13：被授权人
    ,brchno -- 保管箱所在的网点代码
    ,userflag -- 保管箱实际使用人公私标识 11：个人；12：单位（指使用人）
    ,username -- 保管箱实际使用人姓名/名称
    ,useridtp -- 保管箱实际使用人身份证件/证明文件类型
    ,useridno -- 保管箱实际使用人身份证件/证明文件号码
    ,useriddt -- 保管箱实际使用人身份证件/证明文件有效期
    ,usercustno -- 实际使用人客户号
    ,filename -- 文件名
    ,lineno -- 行号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a20tsafeboxdetail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a20tsafeboxdetail exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a20tsafeboxdetail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a20tsafeboxdetail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a20tsafeboxdetail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a20tsafeboxdetail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);