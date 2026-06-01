/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_mpcs_cpmtinst
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_mpcs_cpmtinst drop partition p_${last_date};
alter table ${idl_schema}.aml_mpcs_cpmtinst drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_mpcs_cpmtinst add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_mpcs_cpmtinst partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,instno  -- 机构号
    ,upinstno  -- 上级机构号
    ,instlvl  -- 机构级别
    ,instname  -- 机构名称
    ,instabrname  -- 机构简称
    ,instaddr  -- 机构地址
    ,instenname  -- 机构英文名
    ,instenabrname  -- 机构英文简称
    ,instenaddr  -- 机构英文地址
    ,insttel  -- 机构联系电话
    ,instemail  -- 机构电子邮箱
    ,insttype  -- 机构类型
    ,centflag  -- 机构标识
    ,seqnoprefix  -- 机构
    ,acctinstlvl  -- 清算级别
    ,upacctinst  -- 上级清算机构
    ,bankno  -- 机构行号
    ,citycd  -- 机构城市代码
    ,isleaf  -- 是否网点？
    ,rowstat  -- 状态
    ,upddt  -- 修改日期
    ,updtm  -- 修改时间
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.instno,chr(13),''),chr(10),'')  -- 机构号
    ,replace(replace(t1.upinstno,chr(13),''),chr(10),'')  -- 上级机构号
    ,replace(replace(t1.instlvl,chr(13),''),chr(10),'')  -- 机构级别
    ,replace(replace(t1.instname,chr(13),''),chr(10),'')  -- 机构名称
    ,replace(replace(t1.instabrname,chr(13),''),chr(10),'')  -- 机构简称
    ,replace(replace(t1.instaddr,chr(13),''),chr(10),'')  -- 机构地址
    ,replace(replace(t1.instenname,chr(13),''),chr(10),'')  -- 机构英文名
    ,replace(replace(t1.instenabrname,chr(13),''),chr(10),'')  -- 机构英文简称
    ,replace(replace(t1.instenaddr,chr(13),''),chr(10),'')  -- 机构英文地址
    ,replace(replace(t1.insttel,chr(13),''),chr(10),'')  -- 机构联系电话
    ,replace(replace(t1.instemail,chr(13),''),chr(10),'')  -- 机构电子邮箱
    ,replace(replace(t1.insttype,chr(13),''),chr(10),'')  -- 机构类型
    ,replace(replace(t1.centflag,chr(13),''),chr(10),'')  -- 机构标识
    ,replace(replace(t1.seqnoprefix,chr(13),''),chr(10),'')  -- 机构
    ,replace(replace(t1.acctinstlvl,chr(13),''),chr(10),'')  -- 清算级别
    ,replace(replace(t1.upacctinst,chr(13),''),chr(10),'')  -- 上级清算机构
    ,replace(replace(t1.bankno,chr(13),''),chr(10),'')  -- 机构行号
    ,replace(replace(t1.citycd,chr(13),''),chr(10),'')  -- 机构城市代码
    ,replace(replace(t1.isleaf,chr(13),''),chr(10),'')  -- 是否网点？
    ,replace(replace(t1.rowstat,chr(13),''),chr(10),'')  -- 状态
    ,replace(replace(t1.upddt,chr(13),''),chr(10),'')  -- 修改日期
    ,replace(replace(t1.updtm,chr(13),''),chr(10),'')  -- 修改时间
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mpcs_cpmtinst t1    --行内机构表
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_mpcs_cpmtinst',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);