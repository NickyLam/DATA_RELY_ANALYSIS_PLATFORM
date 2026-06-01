/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0ntm_psb_personal_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.mpcs_a0ntm_psb_personal_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0ntm_psb_personal_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ntm_psb_personal_info_op purge;
drop table ${iol_schema}.mpcs_a0ntm_psb_personal_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_psb_personal_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0ntm_psb_personal_info where 0=1;

create table ${iol_schema}.mpcs_a0ntm_psb_personal_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0ntm_psb_personal_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0ntm_psb_personal_info_cl(
            id -- ID
            ,app_no -- 申请件编号
            ,certi_type -- 证件类型
            ,certi_no -- 身份证号
            ,name -- 姓名
            ,sex -- 性别
            ,birth_date -- 出生日期
            ,marrystate -- 婚姻状况
            ,mobile -- 手机号码
            ,homephone -- 家庭电话
            ,compphone -- 单位电话
            ,qualification -- 学历
            ,degree -- 学位
            ,address -- 通讯地址
            ,reside_addr -- 户籍地址
            ,mate_certp -- 配偶证件类型
            ,mate_cerno -- 配偶证件号码
            ,mate_name -- 配偶姓名
            ,mate_corp -- 配偶工作单位
            ,mate_phone -- 配偶联系电话
            ,addr -- 居住地址
            ,reside_state -- 居住状况
            ,comp_nm -- 工作单位
            ,comp_addr -- 单位地址
            ,profess -- 职业
            ,comp_trade -- 行业
            ,business -- 职务
            ,teach_pose -- 职称
            ,work_date -- 本单位工作起始年份
            ,infodate -- 信息更新日期
            ,create_time -- 创建时间
            ,batchfilename -- 批量文件名
            ,seqno -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0ntm_psb_personal_info_op(
            id -- ID
            ,app_no -- 申请件编号
            ,certi_type -- 证件类型
            ,certi_no -- 身份证号
            ,name -- 姓名
            ,sex -- 性别
            ,birth_date -- 出生日期
            ,marrystate -- 婚姻状况
            ,mobile -- 手机号码
            ,homephone -- 家庭电话
            ,compphone -- 单位电话
            ,qualification -- 学历
            ,degree -- 学位
            ,address -- 通讯地址
            ,reside_addr -- 户籍地址
            ,mate_certp -- 配偶证件类型
            ,mate_cerno -- 配偶证件号码
            ,mate_name -- 配偶姓名
            ,mate_corp -- 配偶工作单位
            ,mate_phone -- 配偶联系电话
            ,addr -- 居住地址
            ,reside_state -- 居住状况
            ,comp_nm -- 工作单位
            ,comp_addr -- 单位地址
            ,profess -- 职业
            ,comp_trade -- 行业
            ,business -- 职务
            ,teach_pose -- 职称
            ,work_date -- 本单位工作起始年份
            ,infodate -- 信息更新日期
            ,create_time -- 创建时间
            ,batchfilename -- 批量文件名
            ,seqno -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.app_no, o.app_no) as app_no -- 申请件编号
    ,nvl(n.certi_type, o.certi_type) as certi_type -- 证件类型
    ,nvl(n.certi_no, o.certi_no) as certi_no -- 身份证号
    ,nvl(n.name, o.name) as name -- 姓名
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.birth_date, o.birth_date) as birth_date -- 出生日期
    ,nvl(n.marrystate, o.marrystate) as marrystate -- 婚姻状况
    ,nvl(n.mobile, o.mobile) as mobile -- 手机号码
    ,nvl(n.homephone, o.homephone) as homephone -- 家庭电话
    ,nvl(n.compphone, o.compphone) as compphone -- 单位电话
    ,nvl(n.qualification, o.qualification) as qualification -- 学历
    ,nvl(n.degree, o.degree) as degree -- 学位
    ,nvl(n.address, o.address) as address -- 通讯地址
    ,nvl(n.reside_addr, o.reside_addr) as reside_addr -- 户籍地址
    ,nvl(n.mate_certp, o.mate_certp) as mate_certp -- 配偶证件类型
    ,nvl(n.mate_cerno, o.mate_cerno) as mate_cerno -- 配偶证件号码
    ,nvl(n.mate_name, o.mate_name) as mate_name -- 配偶姓名
    ,nvl(n.mate_corp, o.mate_corp) as mate_corp -- 配偶工作单位
    ,nvl(n.mate_phone, o.mate_phone) as mate_phone -- 配偶联系电话
    ,nvl(n.addr, o.addr) as addr -- 居住地址
    ,nvl(n.reside_state, o.reside_state) as reside_state -- 居住状况
    ,nvl(n.comp_nm, o.comp_nm) as comp_nm -- 工作单位
    ,nvl(n.comp_addr, o.comp_addr) as comp_addr -- 单位地址
    ,nvl(n.profess, o.profess) as profess -- 职业
    ,nvl(n.comp_trade, o.comp_trade) as comp_trade -- 行业
    ,nvl(n.business, o.business) as business -- 职务
    ,nvl(n.teach_pose, o.teach_pose) as teach_pose -- 职称
    ,nvl(n.work_date, o.work_date) as work_date -- 本单位工作起始年份
    ,nvl(n.infodate, o.infodate) as infodate -- 信息更新日期
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.batchfilename, o.batchfilename) as batchfilename -- 批量文件名
    ,nvl(n.seqno, o.seqno) as seqno -- 序列号
    ,case when
            n.id is null
            and n.app_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
            and n.app_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
            and n.app_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a0ntm_psb_personal_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a0ntm_psb_personal_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
            and o.app_no = n.app_no
where (
        o.id is null
        and o.app_no is null
    )
    or (
        n.id is null
        and n.app_no is null
    )
    or (
        o.certi_type <> n.certi_type
        or o.certi_no <> n.certi_no
        or o.name <> n.name
        or o.sex <> n.sex
        or o.birth_date <> n.birth_date
        or o.marrystate <> n.marrystate
        or o.mobile <> n.mobile
        or o.homephone <> n.homephone
        or o.compphone <> n.compphone
        or o.qualification <> n.qualification
        or o.degree <> n.degree
        or o.address <> n.address
        or o.reside_addr <> n.reside_addr
        or o.mate_certp <> n.mate_certp
        or o.mate_cerno <> n.mate_cerno
        or o.mate_name <> n.mate_name
        or o.mate_corp <> n.mate_corp
        or o.mate_phone <> n.mate_phone
        or o.addr <> n.addr
        or o.reside_state <> n.reside_state
        or o.comp_nm <> n.comp_nm
        or o.comp_addr <> n.comp_addr
        or o.profess <> n.profess
        or o.comp_trade <> n.comp_trade
        or o.business <> n.business
        or o.teach_pose <> n.teach_pose
        or o.work_date <> n.work_date
        or o.infodate <> n.infodate
        or o.create_time <> n.create_time
        or o.batchfilename <> n.batchfilename
        or o.seqno <> n.seqno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0ntm_psb_personal_info_cl(
            id -- ID
            ,app_no -- 申请件编号
            ,certi_type -- 证件类型
            ,certi_no -- 身份证号
            ,name -- 姓名
            ,sex -- 性别
            ,birth_date -- 出生日期
            ,marrystate -- 婚姻状况
            ,mobile -- 手机号码
            ,homephone -- 家庭电话
            ,compphone -- 单位电话
            ,qualification -- 学历
            ,degree -- 学位
            ,address -- 通讯地址
            ,reside_addr -- 户籍地址
            ,mate_certp -- 配偶证件类型
            ,mate_cerno -- 配偶证件号码
            ,mate_name -- 配偶姓名
            ,mate_corp -- 配偶工作单位
            ,mate_phone -- 配偶联系电话
            ,addr -- 居住地址
            ,reside_state -- 居住状况
            ,comp_nm -- 工作单位
            ,comp_addr -- 单位地址
            ,profess -- 职业
            ,comp_trade -- 行业
            ,business -- 职务
            ,teach_pose -- 职称
            ,work_date -- 本单位工作起始年份
            ,infodate -- 信息更新日期
            ,create_time -- 创建时间
            ,batchfilename -- 批量文件名
            ,seqno -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0ntm_psb_personal_info_op(
            id -- ID
            ,app_no -- 申请件编号
            ,certi_type -- 证件类型
            ,certi_no -- 身份证号
            ,name -- 姓名
            ,sex -- 性别
            ,birth_date -- 出生日期
            ,marrystate -- 婚姻状况
            ,mobile -- 手机号码
            ,homephone -- 家庭电话
            ,compphone -- 单位电话
            ,qualification -- 学历
            ,degree -- 学位
            ,address -- 通讯地址
            ,reside_addr -- 户籍地址
            ,mate_certp -- 配偶证件类型
            ,mate_cerno -- 配偶证件号码
            ,mate_name -- 配偶姓名
            ,mate_corp -- 配偶工作单位
            ,mate_phone -- 配偶联系电话
            ,addr -- 居住地址
            ,reside_state -- 居住状况
            ,comp_nm -- 工作单位
            ,comp_addr -- 单位地址
            ,profess -- 职业
            ,comp_trade -- 行业
            ,business -- 职务
            ,teach_pose -- 职称
            ,work_date -- 本单位工作起始年份
            ,infodate -- 信息更新日期
            ,create_time -- 创建时间
            ,batchfilename -- 批量文件名
            ,seqno -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.app_no -- 申请件编号
    ,o.certi_type -- 证件类型
    ,o.certi_no -- 身份证号
    ,o.name -- 姓名
    ,o.sex -- 性别
    ,o.birth_date -- 出生日期
    ,o.marrystate -- 婚姻状况
    ,o.mobile -- 手机号码
    ,o.homephone -- 家庭电话
    ,o.compphone -- 单位电话
    ,o.qualification -- 学历
    ,o.degree -- 学位
    ,o.address -- 通讯地址
    ,o.reside_addr -- 户籍地址
    ,o.mate_certp -- 配偶证件类型
    ,o.mate_cerno -- 配偶证件号码
    ,o.mate_name -- 配偶姓名
    ,o.mate_corp -- 配偶工作单位
    ,o.mate_phone -- 配偶联系电话
    ,o.addr -- 居住地址
    ,o.reside_state -- 居住状况
    ,o.comp_nm -- 工作单位
    ,o.comp_addr -- 单位地址
    ,o.profess -- 职业
    ,o.comp_trade -- 行业
    ,o.business -- 职务
    ,o.teach_pose -- 职称
    ,o.work_date -- 本单位工作起始年份
    ,o.infodate -- 信息更新日期
    ,o.create_time -- 创建时间
    ,o.batchfilename -- 批量文件名
    ,o.seqno -- 序列号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a0ntm_psb_personal_info_bk o
    left join ${iol_schema}.mpcs_a0ntm_psb_personal_info_op n
        on
            o.id = n.id
            and o.app_no = n.app_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a0ntm_psb_personal_info_cl d
        on
            o.id = d.id
            and o.app_no = d.app_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a0ntm_psb_personal_info;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a0ntm_psb_personal_info exchange partition p_19000101 with table ${iol_schema}.mpcs_a0ntm_psb_personal_info_cl;
alter table ${iol_schema}.mpcs_a0ntm_psb_personal_info exchange partition p_20991231 with table ${iol_schema}.mpcs_a0ntm_psb_personal_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0ntm_psb_personal_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ntm_psb_personal_info_op purge;
drop table ${iol_schema}.mpcs_a0ntm_psb_personal_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0ntm_psb_personal_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0ntm_psb_personal_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
