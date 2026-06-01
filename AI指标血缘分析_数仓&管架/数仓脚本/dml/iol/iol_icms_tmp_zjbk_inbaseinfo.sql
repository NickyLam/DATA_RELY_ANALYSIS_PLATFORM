/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_tmp_zjbk_inbaseinfo
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
drop table ${iol_schema}.icms_tmp_zjbk_inbaseinfo_ex purge;
alter table ${iol_schema}.icms_tmp_zjbk_inbaseinfo add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_tmp_zjbk_inbaseinfo truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_tmp_zjbk_inbaseinfo_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_tmp_zjbk_inbaseinfo where 0=1;

insert /*+ append */ into ${iol_schema}.icms_tmp_zjbk_inbaseinfo_ex(
    infrectype -- 信息记录类型
    ,name -- 姓名
    ,idtype -- 证件类型
    ,idnum -- 证件号码
    ,infsurccode -- 信息来源编码
    ,rptdate -- 信息报告日期
    ,rptdatecode -- 报告时点说明代码
    ,cimoc -- 客户资料维护机构代码
    ,customertype -- 客户资料类型
    ,idsgmt_updflag -- 其他标识信息段上报标志
    ,fcsinfsgmt_updflag -- 基本概况信息段上报标志
    ,spsinfsgmt_updflag -- 婚姻信息段上报标志
    ,eduinfsgmt_updflag -- 教育信息段上报标志
    ,octpninfsgmt_updflag -- 职业信息段上报标志
    ,redncinfsgmt_updflag -- 居住地址信息段上报标志
    ,mlginfsgmt_updflag -- 通讯地址信息段上报标志
    ,incinfsgmt_updflag -- 收入信息段上报标志
    ,idnm -- 其他标识个数
    ,idsgmtdata -- 其他标识段
    ,sex -- 性别
    ,dob -- 出生日期
    ,nation -- 国籍
    ,houseadd -- 户籍地址
    ,hhdist -- 户籍所在地行政区划
    ,cellphone -- 手机号码
    ,email -- 电子邮箱
    ,fcsinfoupdate -- 基本概况段信息更新日期
    ,maristatus -- 婚姻状况
    ,sponame -- 配偶姓名
    ,spoidtype -- 配偶证件类型
    ,spoidnum -- 配偶证件号码
    ,spotel -- 配偶联系电话
    ,spscmpynm -- 配偶工作单位
    ,spsinfoupdate -- 婚姻信息段信息更新日期
    ,edulevel -- 学历
    ,acadegree -- 学位
    ,eduinfoupdate -- 教育信息段信息更新日期
    ,empstatus -- 就业状况
    ,cpnname -- 单位名称
    ,cpntype -- 单位性质
    ,industry -- 单位所属行业
    ,cpnaddr -- 单位详细地址
    ,cpnpc -- 单位所在地邮编
    ,cpndist -- 单位所在地行政区划
    ,cpntel -- 单位电话
    ,occupation -- 职业
    ,title -- 职务
    ,techtitle -- 职称
    ,workstartdate -- 本单位工作起始年份
    ,octpninfoupdate -- 职业信息段信息更新日期
    ,resistatus -- 居住状况
    ,resiaddr -- 居住地详细地址
    ,resipc -- 居住地邮编
    ,residist -- 居住地行政区划
    ,hometel -- 住宅电话
    ,resiinfoupdate -- 居住地址信息段信息更新日期
    ,mailaddr -- 通讯地址
    ,mailpc -- 通讯地邮编
    ,maildist -- 通讯地行政区划
    ,mlginfoupdate -- 通讯地址信息段信息更新日期
    ,annlinc -- 自报年收入
    ,taxincome -- 纳税年收入
    ,incinfoupdate -- 收入信息段信息更新日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    infrectype -- 信息记录类型
    ,name -- 姓名
    ,idtype -- 证件类型
    ,idnum -- 证件号码
    ,infsurccode -- 信息来源编码
    ,rptdate -- 信息报告日期
    ,rptdatecode -- 报告时点说明代码
    ,cimoc -- 客户资料维护机构代码
    ,customertype -- 客户资料类型
    ,idsgmt_updflag -- 其他标识信息段上报标志
    ,fcsinfsgmt_updflag -- 基本概况信息段上报标志
    ,spsinfsgmt_updflag -- 婚姻信息段上报标志
    ,eduinfsgmt_updflag -- 教育信息段上报标志
    ,octpninfsgmt_updflag -- 职业信息段上报标志
    ,redncinfsgmt_updflag -- 居住地址信息段上报标志
    ,mlginfsgmt_updflag -- 通讯地址信息段上报标志
    ,incinfsgmt_updflag -- 收入信息段上报标志
    ,idnm -- 其他标识个数
    ,idsgmtdata -- 其他标识段
    ,sex -- 性别
    ,dob -- 出生日期
    ,nation -- 国籍
    ,houseadd -- 户籍地址
    ,hhdist -- 户籍所在地行政区划
    ,cellphone -- 手机号码
    ,email -- 电子邮箱
    ,fcsinfoupdate -- 基本概况段信息更新日期
    ,maristatus -- 婚姻状况
    ,sponame -- 配偶姓名
    ,spoidtype -- 配偶证件类型
    ,spoidnum -- 配偶证件号码
    ,spotel -- 配偶联系电话
    ,spscmpynm -- 配偶工作单位
    ,spsinfoupdate -- 婚姻信息段信息更新日期
    ,edulevel -- 学历
    ,acadegree -- 学位
    ,eduinfoupdate -- 教育信息段信息更新日期
    ,empstatus -- 就业状况
    ,cpnname -- 单位名称
    ,cpntype -- 单位性质
    ,industry -- 单位所属行业
    ,cpnaddr -- 单位详细地址
    ,cpnpc -- 单位所在地邮编
    ,cpndist -- 单位所在地行政区划
    ,cpntel -- 单位电话
    ,occupation -- 职业
    ,title -- 职务
    ,techtitle -- 职称
    ,workstartdate -- 本单位工作起始年份
    ,octpninfoupdate -- 职业信息段信息更新日期
    ,resistatus -- 居住状况
    ,resiaddr -- 居住地详细地址
    ,resipc -- 居住地邮编
    ,residist -- 居住地行政区划
    ,hometel -- 住宅电话
    ,resiinfoupdate -- 居住地址信息段信息更新日期
    ,mailaddr -- 通讯地址
    ,mailpc -- 通讯地邮编
    ,maildist -- 通讯地行政区划
    ,mlginfoupdate -- 通讯地址信息段信息更新日期
    ,annlinc -- 自报年收入
    ,taxincome -- 纳税年收入
    ,incinfoupdate -- 收入信息段信息更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_tmp_zjbk_inbaseinfo
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_tmp_zjbk_inbaseinfo exchange partition p_${batch_date} with table ${iol_schema}.icms_tmp_zjbk_inbaseinfo_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_tmp_zjbk_inbaseinfo to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_tmp_zjbk_inbaseinfo_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_tmp_zjbk_inbaseinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);