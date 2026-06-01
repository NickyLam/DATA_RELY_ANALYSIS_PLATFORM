/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_pos_mercht_info_h_mrmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_pos_mercht_info_h add partition p_mrmsf1 values ('mrmsf1')(
        subpartition p_mrmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mrmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_pos_mercht_info_h partition for ('mrmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_op purge;
drop table ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_tm nologging
compress ${option_switch} for query high
as select
    mercht_seq_num -- 商户序号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_cn_name -- 商户中文名称
    ,mercht_addr -- 商户地址
    ,mercht_local_rg_cd -- 商户地区代码
    ,mercht_sign_dt -- 商户签约日期
    ,stl_acct_type_cd -- 结算账户类型代码
    ,mercht_revo_dt -- 商户撤销日期
    ,co_status_cd -- 合作状态代码
    ,acquiri_bank_num -- 收单行号
    ,open_bank_name -- 开户行名称
    ,acct_id -- 账户编号
    ,cotas_name -- 联系人名称
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,fax_num -- 传真号码
    ,agency_name -- 代理商名称
    ,acct_name -- 账户名称
    ,open_bank_no -- 开户行行号
    ,check_status_cd -- 审核状态代码
    ,recv_org_id -- 收单机构编号
    ,mcc_code -- MCC码
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,cust_mgr_name -- 客户经理姓名
    ,cust_mgr_id -- 客户经理编号
    ,acvmnt_assign_ratio -- 业绩分配比例
    ,zip_cd -- 邮政编码
    ,start_use_dt -- 启用日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_pos_mercht_info_h partition for ('mrmsf1')
where 0=1
;

create table ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_pos_mercht_info_h partition for ('mrmsf1') where 0=1;

create table ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_pos_mercht_info_h partition for ('mrmsf1') where 0=1;

-- 3.1 get new data into table
-- mrms_tbl_direct_mchnt_inf-
insert into ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_tm(
    mercht_seq_num -- 商户序号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_cn_name -- 商户中文名称
    ,mercht_addr -- 商户地址
    ,mercht_local_rg_cd -- 商户地区代码
    ,mercht_sign_dt -- 商户签约日期
    ,stl_acct_type_cd -- 结算账户类型代码
    ,mercht_revo_dt -- 商户撤销日期
    ,co_status_cd -- 合作状态代码
    ,acquiri_bank_num -- 收单行号
    ,open_bank_name -- 开户行名称
    ,acct_id -- 账户编号
    ,cotas_name -- 联系人名称
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,fax_num -- 传真号码
    ,agency_name -- 代理商名称
    ,acct_name -- 账户名称
    ,open_bank_no -- 开户行行号
    ,check_status_cd -- 审核状态代码
    ,recv_org_id -- 收单机构编号
    ,mcc_code -- MCC码
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,cust_mgr_name -- 客户经理姓名
    ,cust_mgr_id -- 客户经理编号
    ,acvmnt_assign_ratio -- 业绩分配比例
    ,zip_cd -- 邮政编码
    ,start_use_dt -- 启用日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 商户序号
    ,'9999' -- 法人编号
    ,P1.MCHT_NO -- 商户编号
    ,P1.MCHT_NM -- 商户中文简称
    ,P1.MCHT_OFFICIAL_NM -- 商户中文名称
    ,P1.MCHT_ADDR -- 商户地址
    ,nvl(trim(P1.AREA_CD),'000000') -- 商户地区代码
    ,${iml_schema}.dateformat_min(P1.CREATE_DATE) -- 商户签约日期
    ,case when r1.target_cd_val is not null then r1.target_cd_val else '@'||P1.CLEAR_TYPE end -- 结算账户类型代码
    ,${iml_schema}.dateformat_max2(P1.EXPIRED_DATE) -- 商户撤销日期
    ,nvl(trim(p1.COO_STATE),'-') -- 合作状态代码
    ,P1.ACQ_BANK -- 收单行号
    ,P1.OPEN_STLNO -- 开户行名称
    ,P1.SETTLE_BANK_NO -- 账户编号
    ,P1.CONTACT -- 联系人名称
    ,P1.CONTACT_JOB -- 联系人证件号码
    ,P1.CONTACT_TEL -- 联系人电话号码
    ,P1.CONTACT_FIX -- 传真号码
    ,P1.OPR_UNIT -- 代理商名称
    ,P1.ACCT_NM -- 账户名称
    ,P1.OPEN_BANK_NO -- 开户行行号
    ,P1.APPLY_STA -- 审核状态代码
    ,P1.ACQ_INST_ID -- 收单机构编号
    ,P1.MCC -- MCC码
    ,P1.BANK_LICENCE_NO -- 统一社会信用代码
    ,P1.DIRECTOR_NM -- 客户经理姓名
    ,P1.DIRECTOR_NO -- 客户经理编号
    ,P1.SCALE -- 业绩分配比例
    ,P1.POSTCODE -- 邮政编码
    ,${iml_schema}.dateformat_min(P1.ENABLE_DT) -- 启用日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_direct_mchnt_inf' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_direct_mchnt_inf p1
    left join ${iml_schema}.ref_pub_cd_map r1 on nvl(trim(P1.CLEAR_TYPE),' ')= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MRMS'
        AND R1.SRC_TAB_EN_NAME= 'MRMS_TBL_DIRECT_MCHNT_INF'
        AND R1.SRC_FIELD_EN_NAME= 'CLEAR_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_POS_MERCHT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'STL_ACCT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_tm 
  	                                group by 
  	                                        mercht_seq_num
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_cl(
            mercht_seq_num -- 商户序号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_cn_name -- 商户中文名称
    ,mercht_addr -- 商户地址
    ,mercht_local_rg_cd -- 商户地区代码
    ,mercht_sign_dt -- 商户签约日期
    ,stl_acct_type_cd -- 结算账户类型代码
    ,mercht_revo_dt -- 商户撤销日期
    ,co_status_cd -- 合作状态代码
    ,acquiri_bank_num -- 收单行号
    ,open_bank_name -- 开户行名称
    ,acct_id -- 账户编号
    ,cotas_name -- 联系人名称
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,fax_num -- 传真号码
    ,agency_name -- 代理商名称
    ,acct_name -- 账户名称
    ,open_bank_no -- 开户行行号
    ,check_status_cd -- 审核状态代码
    ,recv_org_id -- 收单机构编号
    ,mcc_code -- MCC码
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,cust_mgr_name -- 客户经理姓名
    ,cust_mgr_id -- 客户经理编号
    ,acvmnt_assign_ratio -- 业绩分配比例
    ,zip_cd -- 邮政编码
    ,start_use_dt -- 启用日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_op(
            mercht_seq_num -- 商户序号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_cn_name -- 商户中文名称
    ,mercht_addr -- 商户地址
    ,mercht_local_rg_cd -- 商户地区代码
    ,mercht_sign_dt -- 商户签约日期
    ,stl_acct_type_cd -- 结算账户类型代码
    ,mercht_revo_dt -- 商户撤销日期
    ,co_status_cd -- 合作状态代码
    ,acquiri_bank_num -- 收单行号
    ,open_bank_name -- 开户行名称
    ,acct_id -- 账户编号
    ,cotas_name -- 联系人名称
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,fax_num -- 传真号码
    ,agency_name -- 代理商名称
    ,acct_name -- 账户名称
    ,open_bank_no -- 开户行行号
    ,check_status_cd -- 审核状态代码
    ,recv_org_id -- 收单机构编号
    ,mcc_code -- MCC码
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,cust_mgr_name -- 客户经理姓名
    ,cust_mgr_id -- 客户经理编号
    ,acvmnt_assign_ratio -- 业绩分配比例
    ,zip_cd -- 邮政编码
    ,start_use_dt -- 启用日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mercht_seq_num, o.mercht_seq_num) as mercht_seq_num -- 商户序号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.mercht_cn_abbr, o.mercht_cn_abbr) as mercht_cn_abbr -- 商户中文简称
    ,nvl(n.mercht_cn_name, o.mercht_cn_name) as mercht_cn_name -- 商户中文名称
    ,nvl(n.mercht_addr, o.mercht_addr) as mercht_addr -- 商户地址
    ,nvl(n.mercht_local_rg_cd, o.mercht_local_rg_cd) as mercht_local_rg_cd -- 商户地区代码
    ,nvl(n.mercht_sign_dt, o.mercht_sign_dt) as mercht_sign_dt -- 商户签约日期
    ,nvl(n.stl_acct_type_cd, o.stl_acct_type_cd) as stl_acct_type_cd -- 结算账户类型代码
    ,nvl(n.mercht_revo_dt, o.mercht_revo_dt) as mercht_revo_dt -- 商户撤销日期
    ,nvl(n.co_status_cd, o.co_status_cd) as co_status_cd -- 合作状态代码
    ,nvl(n.acquiri_bank_num, o.acquiri_bank_num) as acquiri_bank_num -- 收单行号
    ,nvl(n.open_bank_name, o.open_bank_name) as open_bank_name -- 开户行名称
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cotas_name, o.cotas_name) as cotas_name -- 联系人名称
    ,nvl(n.cotas_cert_no, o.cotas_cert_no) as cotas_cert_no -- 联系人证件号码
    ,nvl(n.cotas_tel_num, o.cotas_tel_num) as cotas_tel_num -- 联系人电话号码
    ,nvl(n.fax_num, o.fax_num) as fax_num -- 传真号码
    ,nvl(n.agency_name, o.agency_name) as agency_name -- 代理商名称
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.open_bank_no, o.open_bank_no) as open_bank_no -- 开户行行号
    ,nvl(n.check_status_cd, o.check_status_cd) as check_status_cd -- 审核状态代码
    ,nvl(n.recv_org_id, o.recv_org_id) as recv_org_id -- 收单机构编号
    ,nvl(n.mcc_code, o.mcc_code) as mcc_code -- MCC码
    ,nvl(n.unify_soci_crdt_cd, o.unify_soci_crdt_cd) as unify_soci_crdt_cd -- 统一社会信用代码
    ,nvl(n.cust_mgr_name, o.cust_mgr_name) as cust_mgr_name -- 客户经理姓名
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.acvmnt_assign_ratio, o.acvmnt_assign_ratio) as acvmnt_assign_ratio -- 业绩分配比例
    ,nvl(n.zip_cd, o.zip_cd) as zip_cd -- 邮政编码
    ,nvl(n.start_use_dt, o.start_use_dt) as start_use_dt -- 启用日期
    ,case when
            n.mercht_seq_num is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mercht_seq_num is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mercht_seq_num is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_tm n
    full join (select * from ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.mercht_seq_num = n.mercht_seq_num
            and o.lp_id = n.lp_id
where (
        o.mercht_seq_num is null
        and o.lp_id is null
    )
    or (
        n.mercht_seq_num is null
        and n.lp_id is null
    )
    or (
        o.mercht_id <> n.mercht_id
        or o.mercht_cn_abbr <> n.mercht_cn_abbr
        or o.mercht_cn_name <> n.mercht_cn_name
        or o.mercht_addr <> n.mercht_addr
        or o.mercht_local_rg_cd <> n.mercht_local_rg_cd
        or o.mercht_sign_dt <> n.mercht_sign_dt
        or o.stl_acct_type_cd <> n.stl_acct_type_cd
        or o.mercht_revo_dt <> n.mercht_revo_dt
        or o.co_status_cd <> n.co_status_cd
        or o.acquiri_bank_num <> n.acquiri_bank_num
        or o.open_bank_name <> n.open_bank_name
        or o.acct_id <> n.acct_id
        or o.cotas_name <> n.cotas_name
        or o.cotas_cert_no <> n.cotas_cert_no
        or o.cotas_tel_num <> n.cotas_tel_num
        or o.fax_num <> n.fax_num
        or o.agency_name <> n.agency_name
        or o.acct_name <> n.acct_name
        or o.open_bank_no <> n.open_bank_no
        or o.check_status_cd <> n.check_status_cd
        or o.recv_org_id <> n.recv_org_id
        or o.mcc_code <> n.mcc_code
        or o.unify_soci_crdt_cd <> n.unify_soci_crdt_cd
        or o.cust_mgr_name <> n.cust_mgr_name
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.acvmnt_assign_ratio <> n.acvmnt_assign_ratio
        or o.zip_cd <> n.zip_cd
        or o.start_use_dt <> n.start_use_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_cl(
            mercht_seq_num -- 商户序号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_cn_name -- 商户中文名称
    ,mercht_addr -- 商户地址
    ,mercht_local_rg_cd -- 商户地区代码
    ,mercht_sign_dt -- 商户签约日期
    ,stl_acct_type_cd -- 结算账户类型代码
    ,mercht_revo_dt -- 商户撤销日期
    ,co_status_cd -- 合作状态代码
    ,acquiri_bank_num -- 收单行号
    ,open_bank_name -- 开户行名称
    ,acct_id -- 账户编号
    ,cotas_name -- 联系人名称
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,fax_num -- 传真号码
    ,agency_name -- 代理商名称
    ,acct_name -- 账户名称
    ,open_bank_no -- 开户行行号
    ,check_status_cd -- 审核状态代码
    ,recv_org_id -- 收单机构编号
    ,mcc_code -- MCC码
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,cust_mgr_name -- 客户经理姓名
    ,cust_mgr_id -- 客户经理编号
    ,acvmnt_assign_ratio -- 业绩分配比例
    ,zip_cd -- 邮政编码
    ,start_use_dt -- 启用日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_op(
            mercht_seq_num -- 商户序号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_cn_name -- 商户中文名称
    ,mercht_addr -- 商户地址
    ,mercht_local_rg_cd -- 商户地区代码
    ,mercht_sign_dt -- 商户签约日期
    ,stl_acct_type_cd -- 结算账户类型代码
    ,mercht_revo_dt -- 商户撤销日期
    ,co_status_cd -- 合作状态代码
    ,acquiri_bank_num -- 收单行号
    ,open_bank_name -- 开户行名称
    ,acct_id -- 账户编号
    ,cotas_name -- 联系人名称
    ,cotas_cert_no -- 联系人证件号码
    ,cotas_tel_num -- 联系人电话号码
    ,fax_num -- 传真号码
    ,agency_name -- 代理商名称
    ,acct_name -- 账户名称
    ,open_bank_no -- 开户行行号
    ,check_status_cd -- 审核状态代码
    ,recv_org_id -- 收单机构编号
    ,mcc_code -- MCC码
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,cust_mgr_name -- 客户经理姓名
    ,cust_mgr_id -- 客户经理编号
    ,acvmnt_assign_ratio -- 业绩分配比例
    ,zip_cd -- 邮政编码
    ,start_use_dt -- 启用日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mercht_seq_num -- 商户序号
    ,o.lp_id -- 法人编号
    ,o.mercht_id -- 商户编号
    ,o.mercht_cn_abbr -- 商户中文简称
    ,o.mercht_cn_name -- 商户中文名称
    ,o.mercht_addr -- 商户地址
    ,o.mercht_local_rg_cd -- 商户地区代码
    ,o.mercht_sign_dt -- 商户签约日期
    ,o.stl_acct_type_cd -- 结算账户类型代码
    ,o.mercht_revo_dt -- 商户撤销日期
    ,o.co_status_cd -- 合作状态代码
    ,o.acquiri_bank_num -- 收单行号
    ,o.open_bank_name -- 开户行名称
    ,o.acct_id -- 账户编号
    ,o.cotas_name -- 联系人名称
    ,o.cotas_cert_no -- 联系人证件号码
    ,o.cotas_tel_num -- 联系人电话号码
    ,o.fax_num -- 传真号码
    ,o.agency_name -- 代理商名称
    ,o.acct_name -- 账户名称
    ,o.open_bank_no -- 开户行行号
    ,o.check_status_cd -- 审核状态代码
    ,o.recv_org_id -- 收单机构编号
    ,o.mcc_code -- MCC码
    ,o.unify_soci_crdt_cd -- 统一社会信用代码
    ,o.cust_mgr_name -- 客户经理姓名
    ,o.cust_mgr_id -- 客户经理编号
    ,o.acvmnt_assign_ratio -- 业绩分配比例
    ,o.zip_cd -- 邮政编码
    ,o.start_use_dt -- 启用日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_bk o
    left join ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_op n
        on
            o.mercht_seq_num = n.mercht_seq_num
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_cl d
        on
            o.mercht_seq_num = d.mercht_seq_num
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_pos_mercht_info_h;
--alter table ${iml_schema}.pty_pos_mercht_info_h truncate partition for ('mrmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_pos_mercht_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mrmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_pos_mercht_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_pos_mercht_info_h modify partition p_mrmsf1 
add subpartition p_mrmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_pos_mercht_info_h exchange subpartition p_mrmsf1_${batch_date} with table ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_cl;
alter table ${iml_schema}.pty_pos_mercht_info_h exchange subpartition p_mrmsf1_20991231 with table ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_pos_mercht_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_op purge;
drop table ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_pos_mercht_info_h_mrmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_pos_mercht_info_h', partname => 'p_mrmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
