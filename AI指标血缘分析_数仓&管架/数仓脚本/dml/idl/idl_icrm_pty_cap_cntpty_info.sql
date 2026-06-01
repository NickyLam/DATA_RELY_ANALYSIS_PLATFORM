/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_pty_cap_cntpty_info
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
alter table ${idl_schema}.icrm_pty_cap_cntpty_info drop partition p_${last_date};
alter table ${idl_schema}.icrm_pty_cap_cntpty_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_pty_cap_cntpty_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_pty_cap_cntpty_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,party_id  -- 当事人编号
    ,lp_id  -- 法人编号
    ,dept_id  -- 部门编号
    ,cntpty_id  -- 交易对手编号
    ,cntpty_abbr  -- 交易对手简称
    ,cntpty_fname  -- 交易对手全称
    ,cntpty_en_abbr  -- 交易对手英文简称
    ,cntpty_en_name  -- 交易对手英文名称
    ,elec_cert_name  -- 电子证书名称
    ,elec_cert_id  -- 电子证书编号
    ,elec_cert_flg  -- 电子证书标志
    ,intnal_rating_level_cd  -- 内部评级等级代码
    ,cotas_name  -- 联系人名称
    ,tel_num  -- 电话号码
    ,fax_num  -- 传真号码
    ,issuer_flg  -- 发行人标志
    ,issuer_id  -- 发行人编号
    ,guartor_flg  -- 担保人标志
    ,guartor_id  -- 担保人编号
    ,fin_inst_flg  -- 金融机构标志
    ,trust_org_flg  -- 托管机构标志
    ,indus_type_cd  -- 行业类型代码
    ,elec_ibank_no  -- 电子联行号
    ,pay_bk_bank_no  -- 支付行行号
    ,swift_id  -- SWIFT编号
    ,cust_id  -- 客户编号
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.party_id,chr(13),''),chr(10),'')  -- 当事人编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.dept_id,chr(13),''),chr(10),'')  -- 部门编号
    ,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'')  -- 交易对手编号
    ,replace(replace(t1.cntpty_abbr,chr(13),''),chr(10),'')  -- 交易对手简称
    ,replace(replace(t1.cntpty_fname,chr(13),''),chr(10),'')  -- 交易对手全称
    ,replace(replace(t1.cntpty_en_abbr,chr(13),''),chr(10),'')  -- 交易对手英文简称
    ,replace(replace(t1.cntpty_en_name,chr(13),''),chr(10),'')  -- 交易对手英文名称
    ,replace(replace(t1.elec_cert_name,chr(13),''),chr(10),'')  -- 电子证书名称
    ,replace(replace(t1.elec_cert_id,chr(13),''),chr(10),'')  -- 电子证书编号
    ,replace(replace(t1.elec_cert_flg,chr(13),''),chr(10),'')  -- 电子证书标志
    ,replace(replace(t1.intnal_rating_level_cd,chr(13),''),chr(10),'')  -- 内部评级等级代码
    ,replace(replace(t1.cotas_name,chr(13),''),chr(10),'')  -- 联系人名称
    ,replace(replace(t1.tel_num,chr(13),''),chr(10),'')  -- 电话号码
    ,replace(replace(t1.fax_num,chr(13),''),chr(10),'')  -- 传真号码
    ,replace(replace(t1.issuer_flg,chr(13),''),chr(10),'')  -- 发行人标志
    ,replace(replace(t1.issuer_id,chr(13),''),chr(10),'')  -- 发行人编号
    ,replace(replace(t1.guartor_flg,chr(13),''),chr(10),'')  -- 担保人标志
    ,replace(replace(t1.guartor_id,chr(13),''),chr(10),'')  -- 担保人编号
    ,replace(replace(t1.fin_inst_flg,chr(13),''),chr(10),'')  -- 金融机构标志
    ,replace(replace(t1.trust_org_flg,chr(13),''),chr(10),'')  -- 托管机构标志
    ,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'')  -- 行业类型代码
    ,replace(replace(t1.elec_ibank_no,chr(13),''),chr(10),'')  -- 电子联行号
    ,replace(replace(t1.pay_bk_bank_no,chr(13),''),chr(10),'')  -- 支付行行号
    ,replace(replace(t1.swift_id,chr(13),''),chr(10),'')  -- SWIFT编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.pty_cap_cntpty_info t1    --资金交易对手信息
where t1.create_dt<= to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_pty_cap_cntpty_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);