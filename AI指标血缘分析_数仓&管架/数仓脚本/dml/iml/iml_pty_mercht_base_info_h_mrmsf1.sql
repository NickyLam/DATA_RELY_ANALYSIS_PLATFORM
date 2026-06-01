/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_mercht_base_info_h_mrmsf1
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
alter table ${iml_schema}.pty_mercht_base_info_h add partition p_mrmsf1 values ('mrmsf1')(
        subpartition p_mrmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mrmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_mercht_base_info_h_mrmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_mercht_base_info_h partition for ('mrmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_mercht_base_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.pty_mercht_base_info_h_mrmsf1_op purge;
drop table ${iml_schema}.pty_mercht_base_info_h_mrmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_mercht_base_info_h_mrmsf1_tm nologging
compress ${option_switch} for query high
as select
    mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,mercht_name -- 商户名称
    ,risk_lev_cd -- 风险级别代码
    ,mercht_status_cd -- 商户状态代码
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_en_name -- 商户英文名称
    ,rg_cd -- 区域代码
    ,clear_rg_cd -- 清算区域代码
    ,mercht_addr -- 商户地址
    ,corp_addr -- 公司地址
    ,mcc_code -- MCC码
    ,corp_char_cd -- 企业性质代码
    ,super_mercht_id -- 上级商户编号
    ,mercht_kind_cd -- 商户种类代码
    ,connet_way_cd -- 连接方式代码
    ,cotas_name -- 联系人姓名
    ,zip_cd -- 邮政编码
    ,cotas_e_mail -- 联系人电子邮箱
    ,cotas_tel_num -- 联系人电话号码
    ,lp_name -- 法人姓名
    ,lp_cert_type_cd -- 法人证件类型代码
    ,lp_cert_no -- 法人证件号码
    ,lp_phone -- 法人联系电话
    ,fax -- 传真
    ,telex -- 电传
    ,rgst_addr -- 注册地址
    ,appl_dt -- 申请日期
    ,start_use_dt -- 启用日期
    ,sign_org_id -- 签约机构编号
    ,sign_netw_id -- 签约网点编号
    ,sign_dt -- 签约日期
    ,sign_teller_name -- 签约柜员名称
    ,recall_sign_dt -- 撤消签约日期
    ,recall_sign_teller_name -- 撤消签约柜员名称
    ,cust_mgr_id -- 客户经理编号
    ,mercht_belong_org_id -- 商户所属机构编号
    ,acquiri_bank_name -- 收单行名称
    ,recv_bill_brch_id -- 收单分行编号
    ,mercht_rating_calc_score -- 商户评级计算评分
    ,mercht_rating_info -- 商户评级信息
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_mercht_base_info_h partition for ('mrmsf1')
where 0=1
;

create table ${iml_schema}.pty_mercht_base_info_h_mrmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_mercht_base_info_h partition for ('mrmsf1') where 0=1;

create table ${iml_schema}.pty_mercht_base_info_h_mrmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_mercht_base_info_h partition for ('mrmsf1') where 0=1;

-- 3.1 get new data into table
-- mrms_tbl_mcht_base_inf-
insert into ${iml_schema}.pty_mercht_base_info_h_mrmsf1_tm(
    mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,mercht_name -- 商户名称
    ,risk_lev_cd -- 风险级别代码
    ,mercht_status_cd -- 商户状态代码
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_en_name -- 商户英文名称
    ,rg_cd -- 区域代码
    ,clear_rg_cd -- 清算区域代码
    ,mercht_addr -- 商户地址
    ,corp_addr -- 公司地址
    ,mcc_code -- MCC码
    ,corp_char_cd -- 企业性质代码
    ,super_mercht_id -- 上级商户编号
    ,mercht_kind_cd -- 商户种类代码
    ,connet_way_cd -- 连接方式代码
    ,cotas_name -- 联系人姓名
    ,zip_cd -- 邮政编码
    ,cotas_e_mail -- 联系人电子邮箱
    ,cotas_tel_num -- 联系人电话号码
    ,lp_name -- 法人姓名
    ,lp_cert_type_cd -- 法人证件类型代码
    ,lp_cert_no -- 法人证件号码
    ,lp_phone -- 法人联系电话
    ,fax -- 传真
    ,telex -- 电传
    ,rgst_addr -- 注册地址
    ,appl_dt -- 申请日期
    ,start_use_dt -- 启用日期
    ,sign_org_id -- 签约机构编号
    ,sign_netw_id -- 签约网点编号
    ,sign_dt -- 签约日期
    ,sign_teller_name -- 签约柜员名称
    ,recall_sign_dt -- 撤消签约日期
    ,recall_sign_teller_name -- 撤消签约柜员名称
    ,cust_mgr_id -- 客户经理编号
    ,mercht_belong_org_id -- 商户所属机构编号
    ,acquiri_bank_name -- 收单行名称
    ,recv_bill_brch_id -- 收单分行编号
    ,mercht_rating_calc_score -- 商户评级计算评分
    ,mercht_rating_info -- 商户评级信息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.MCHT_NO -- 商户编号
    ,'9999' -- 法人编号
    ,P1.MCHT_NM -- 商户名称
    ,P1.RISL_LVL -- 风险级别代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||p1.MCHT_STATUS END -- 商户状态代码
    ,P1.MCHT_CN_ABBR -- 商户中文简称
    ,P1.ENG_NAME -- 商户英文名称
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||p1.AREA_NO END -- 区域代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||p1.SETTLE_AREA_NO END -- 清算区域代码
    ,P1.ADDR -- 商户地址
    ,P1.HOME_PAGE -- 公司地址
    ,P1.MCC -- MCC码
    ,P1.ETPS_ATTR -- 企业性质代码
    ,P1.MNG_MCHT_ID -- 上级商户编号
    ,P1.MCHT_GROUP_FLAG -- 商户种类代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||p1.CONN_TYPE END -- 连接方式代码
    ,P1.CONTACT -- 联系人姓名
    ,P1.POST_CODE -- 邮政编码
    ,P1.COMM_EMAIL -- 联系人电子邮箱
    ,P1.COMM_TEL -- 联系人电话号码
    ,P1.MANAGER -- 法人姓名
    ,P1.ARTIF_CERTIF_TP -- 法人证件类型代码
    ,P1.IDENTITY_NO -- 法人证件号码
    ,P1.MANAGER_TEL -- 法人联系电话
    ,P1.FAX -- 传真
    ,P1.ELECTROFAX -- 电传
    ,P1.REG_ADDR -- 注册地址
    ,${iml_schema}.DATEFORMAT_MIN(P1.APPLY_DATE) -- 申请日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.ENABLE_DATE) -- 启用日期
    ,P1.SIGN_INST_ID -- 签约机构编号
    ,P1.AGR_BR -- 签约网点编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.PROL_DATE) -- 签约日期
    ,P1.PROL_TLR -- 签约柜员名称
    ,${iml_schema}.DATEFORMAT_MIN(P1.CLOSE_DATE) -- 撤消签约日期
    ,P1.CLOSE_TLR -- 撤消签约柜员名称
    ,P1.OPER_NO -- 客户经理编号
    ,P1.ACQ_INST_ID -- 商户所属机构编号
    ,P1.ACQ_BK_NAME -- 收单行名称
    ,P1.BANK_NO -- 收单分行编号
    ,P1.MCHT_GRADE -- 商户评级计算评分
    ,P1.RESERVED1 -- 商户评级信息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_mcht_base_inf' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_mcht_base_inf p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.MCHT_STATUS= R1.SRC_CODE_VAL
AND R1.SORC_SYS_CD= 'MRMS'
AND R1.SRC_TAB_EN_NAME= 'MRMS_TBL_MCHT_BASE_INF'
AND R1.SRC_FIELD_EN_NAME= 'MCHT_STATUS'
AND R1.TARGET_TAB_EN_NAME= 'PTY_MERCHT_BASE_INFO_H'
AND R1.TARGET_TAB_FIELD_EN_NAME= 'MERCHT_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.AREA_NO= R2.SRC_CODE_VAL
AND R2.SORC_SYS_CD= 'MRMS'
AND R2.SRC_TAB_EN_NAME= 'MRMS_TBL_MCHT_BASE_INF'
AND R2.SRC_FIELD_EN_NAME= 'AREA_NO'
AND R2.TARGET_TAB_EN_NAME= 'PTY_MERCHT_BASE_INFO_H'
AND R2.TARGET_TAB_FIELD_EN_NAME= 'RG_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.SETTLE_AREA_NO= R3.SRC_CODE_VAL
AND R3.SORC_SYS_CD= 'MRMS'
AND R3.SRC_TAB_EN_NAME= 'MRMS_TBL_MCHT_BASE_INF'
AND R3.SRC_FIELD_EN_NAME= 'SETTLE_AREA_NO'
AND R3.TARGET_TAB_EN_NAME= 'PTY_MERCHT_BASE_INFO_H'
AND R3.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_RG_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.CONN_TYPE= R4.SRC_CODE_VAL
AND R4.SORC_SYS_CD= 'MRMS'
AND R4.SRC_TAB_EN_NAME= 'MRMS_TBL_MCHT_BASE_INF'
AND R4.SRC_FIELD_EN_NAME= 'CONN_TYPE'
AND R4.TARGET_TAB_EN_NAME= 'PTY_MERCHT_BASE_INFO_H'
AND R4.TARGET_TAB_FIELD_EN_NAME= 'CONNET_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_mercht_base_info_h_mrmsf1_tm 
  	                                group by 
  	                                        mercht_id
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
        into ${iml_schema}.pty_mercht_base_info_h_mrmsf1_cl(
            mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,mercht_name -- 商户名称
    ,risk_lev_cd -- 风险级别代码
    ,mercht_status_cd -- 商户状态代码
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_en_name -- 商户英文名称
    ,rg_cd -- 区域代码
    ,clear_rg_cd -- 清算区域代码
    ,mercht_addr -- 商户地址
    ,corp_addr -- 公司地址
    ,mcc_code -- MCC码
    ,corp_char_cd -- 企业性质代码
    ,super_mercht_id -- 上级商户编号
    ,mercht_kind_cd -- 商户种类代码
    ,connet_way_cd -- 连接方式代码
    ,cotas_name -- 联系人姓名
    ,zip_cd -- 邮政编码
    ,cotas_e_mail -- 联系人电子邮箱
    ,cotas_tel_num -- 联系人电话号码
    ,lp_name -- 法人姓名
    ,lp_cert_type_cd -- 法人证件类型代码
    ,lp_cert_no -- 法人证件号码
    ,lp_phone -- 法人联系电话
    ,fax -- 传真
    ,telex -- 电传
    ,rgst_addr -- 注册地址
    ,appl_dt -- 申请日期
    ,start_use_dt -- 启用日期
    ,sign_org_id -- 签约机构编号
    ,sign_netw_id -- 签约网点编号
    ,sign_dt -- 签约日期
    ,sign_teller_name -- 签约柜员名称
    ,recall_sign_dt -- 撤消签约日期
    ,recall_sign_teller_name -- 撤消签约柜员名称
    ,cust_mgr_id -- 客户经理编号
    ,mercht_belong_org_id -- 商户所属机构编号
    ,acquiri_bank_name -- 收单行名称
    ,recv_bill_brch_id -- 收单分行编号
    ,mercht_rating_calc_score -- 商户评级计算评分
    ,mercht_rating_info -- 商户评级信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_mercht_base_info_h_mrmsf1_op(
            mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,mercht_name -- 商户名称
    ,risk_lev_cd -- 风险级别代码
    ,mercht_status_cd -- 商户状态代码
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_en_name -- 商户英文名称
    ,rg_cd -- 区域代码
    ,clear_rg_cd -- 清算区域代码
    ,mercht_addr -- 商户地址
    ,corp_addr -- 公司地址
    ,mcc_code -- MCC码
    ,corp_char_cd -- 企业性质代码
    ,super_mercht_id -- 上级商户编号
    ,mercht_kind_cd -- 商户种类代码
    ,connet_way_cd -- 连接方式代码
    ,cotas_name -- 联系人姓名
    ,zip_cd -- 邮政编码
    ,cotas_e_mail -- 联系人电子邮箱
    ,cotas_tel_num -- 联系人电话号码
    ,lp_name -- 法人姓名
    ,lp_cert_type_cd -- 法人证件类型代码
    ,lp_cert_no -- 法人证件号码
    ,lp_phone -- 法人联系电话
    ,fax -- 传真
    ,telex -- 电传
    ,rgst_addr -- 注册地址
    ,appl_dt -- 申请日期
    ,start_use_dt -- 启用日期
    ,sign_org_id -- 签约机构编号
    ,sign_netw_id -- 签约网点编号
    ,sign_dt -- 签约日期
    ,sign_teller_name -- 签约柜员名称
    ,recall_sign_dt -- 撤消签约日期
    ,recall_sign_teller_name -- 撤消签约柜员名称
    ,cust_mgr_id -- 客户经理编号
    ,mercht_belong_org_id -- 商户所属机构编号
    ,acquiri_bank_name -- 收单行名称
    ,recv_bill_brch_id -- 收单分行编号
    ,mercht_rating_calc_score -- 商户评级计算评分
    ,mercht_rating_info -- 商户评级信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.mercht_name, o.mercht_name) as mercht_name -- 商户名称
    ,nvl(n.risk_lev_cd, o.risk_lev_cd) as risk_lev_cd -- 风险级别代码
    ,nvl(n.mercht_status_cd, o.mercht_status_cd) as mercht_status_cd -- 商户状态代码
    ,nvl(n.mercht_cn_abbr, o.mercht_cn_abbr) as mercht_cn_abbr -- 商户中文简称
    ,nvl(n.mercht_en_name, o.mercht_en_name) as mercht_en_name -- 商户英文名称
    ,nvl(n.rg_cd, o.rg_cd) as rg_cd -- 区域代码
    ,nvl(n.clear_rg_cd, o.clear_rg_cd) as clear_rg_cd -- 清算区域代码
    ,nvl(n.mercht_addr, o.mercht_addr) as mercht_addr -- 商户地址
    ,nvl(n.corp_addr, o.corp_addr) as corp_addr -- 公司地址
    ,nvl(n.mcc_code, o.mcc_code) as mcc_code -- MCC码
    ,nvl(n.corp_char_cd, o.corp_char_cd) as corp_char_cd -- 企业性质代码
    ,nvl(n.super_mercht_id, o.super_mercht_id) as super_mercht_id -- 上级商户编号
    ,nvl(n.mercht_kind_cd, o.mercht_kind_cd) as mercht_kind_cd -- 商户种类代码
    ,nvl(n.connet_way_cd, o.connet_way_cd) as connet_way_cd -- 连接方式代码
    ,nvl(n.cotas_name, o.cotas_name) as cotas_name -- 联系人姓名
    ,nvl(n.zip_cd, o.zip_cd) as zip_cd -- 邮政编码
    ,nvl(n.cotas_e_mail, o.cotas_e_mail) as cotas_e_mail -- 联系人电子邮箱
    ,nvl(n.cotas_tel_num, o.cotas_tel_num) as cotas_tel_num -- 联系人电话号码
    ,nvl(n.lp_name, o.lp_name) as lp_name -- 法人姓名
    ,nvl(n.lp_cert_type_cd, o.lp_cert_type_cd) as lp_cert_type_cd -- 法人证件类型代码
    ,nvl(n.lp_cert_no, o.lp_cert_no) as lp_cert_no -- 法人证件号码
    ,nvl(n.lp_phone, o.lp_phone) as lp_phone -- 法人联系电话
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.telex, o.telex) as telex -- 电传
    ,nvl(n.rgst_addr, o.rgst_addr) as rgst_addr -- 注册地址
    ,nvl(n.appl_dt, o.appl_dt) as appl_dt -- 申请日期
    ,nvl(n.start_use_dt, o.start_use_dt) as start_use_dt -- 启用日期
    ,nvl(n.sign_org_id, o.sign_org_id) as sign_org_id -- 签约机构编号
    ,nvl(n.sign_netw_id, o.sign_netw_id) as sign_netw_id -- 签约网点编号
    ,nvl(n.sign_dt, o.sign_dt) as sign_dt -- 签约日期
    ,nvl(n.sign_teller_name, o.sign_teller_name) as sign_teller_name -- 签约柜员名称
    ,nvl(n.recall_sign_dt, o.recall_sign_dt) as recall_sign_dt -- 撤消签约日期
    ,nvl(n.recall_sign_teller_name, o.recall_sign_teller_name) as recall_sign_teller_name -- 撤消签约柜员名称
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.mercht_belong_org_id, o.mercht_belong_org_id) as mercht_belong_org_id -- 商户所属机构编号
    ,nvl(n.acquiri_bank_name, o.acquiri_bank_name) as acquiri_bank_name -- 收单行名称
    ,nvl(n.recv_bill_brch_id, o.recv_bill_brch_id) as recv_bill_brch_id -- 收单分行编号
    ,nvl(n.mercht_rating_calc_score, o.mercht_rating_calc_score) as mercht_rating_calc_score -- 商户评级计算评分
    ,nvl(n.mercht_rating_info, o.mercht_rating_info) as mercht_rating_info -- 商户评级信息
    ,case when
            n.mercht_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mercht_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mercht_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_mercht_base_info_h_mrmsf1_tm n
    full join (select * from ${iml_schema}.pty_mercht_base_info_h_mrmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.mercht_id = n.mercht_id
            and o.lp_id = n.lp_id
where (
        o.mercht_id is null
        and o.lp_id is null
    )
    or (
        n.mercht_id is null
        and n.lp_id is null
    )
    or (
        o.mercht_name <> n.mercht_name
        or o.risk_lev_cd <> n.risk_lev_cd
        or o.mercht_status_cd <> n.mercht_status_cd
        or o.mercht_cn_abbr <> n.mercht_cn_abbr
        or o.mercht_en_name <> n.mercht_en_name
        or o.rg_cd <> n.rg_cd
        or o.clear_rg_cd <> n.clear_rg_cd
        or o.mercht_addr <> n.mercht_addr
        or o.corp_addr <> n.corp_addr
        or o.mcc_code <> n.mcc_code
        or o.corp_char_cd <> n.corp_char_cd
        or o.super_mercht_id <> n.super_mercht_id
        or o.mercht_kind_cd <> n.mercht_kind_cd
        or o.connet_way_cd <> n.connet_way_cd
        or o.cotas_name <> n.cotas_name
        or o.zip_cd <> n.zip_cd
        or o.cotas_e_mail <> n.cotas_e_mail
        or o.cotas_tel_num <> n.cotas_tel_num
        or o.lp_name <> n.lp_name
        or o.lp_cert_type_cd <> n.lp_cert_type_cd
        or o.lp_cert_no <> n.lp_cert_no
        or o.lp_phone <> n.lp_phone
        or o.fax <> n.fax
        or o.telex <> n.telex
        or o.rgst_addr <> n.rgst_addr
        or o.appl_dt <> n.appl_dt
        or o.start_use_dt <> n.start_use_dt
        or o.sign_org_id <> n.sign_org_id
        or o.sign_netw_id <> n.sign_netw_id
        or o.sign_dt <> n.sign_dt
        or o.sign_teller_name <> n.sign_teller_name
        or o.recall_sign_dt <> n.recall_sign_dt
        or o.recall_sign_teller_name <> n.recall_sign_teller_name
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.mercht_belong_org_id <> n.mercht_belong_org_id
        or o.acquiri_bank_name <> n.acquiri_bank_name
        or o.recv_bill_brch_id <> n.recv_bill_brch_id
        or o.mercht_rating_calc_score <> n.mercht_rating_calc_score
        or o.mercht_rating_info <> n.mercht_rating_info
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_mercht_base_info_h_mrmsf1_cl(
            mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,mercht_name -- 商户名称
    ,risk_lev_cd -- 风险级别代码
    ,mercht_status_cd -- 商户状态代码
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_en_name -- 商户英文名称
    ,rg_cd -- 区域代码
    ,clear_rg_cd -- 清算区域代码
    ,mercht_addr -- 商户地址
    ,corp_addr -- 公司地址
    ,mcc_code -- MCC码
    ,corp_char_cd -- 企业性质代码
    ,super_mercht_id -- 上级商户编号
    ,mercht_kind_cd -- 商户种类代码
    ,connet_way_cd -- 连接方式代码
    ,cotas_name -- 联系人姓名
    ,zip_cd -- 邮政编码
    ,cotas_e_mail -- 联系人电子邮箱
    ,cotas_tel_num -- 联系人电话号码
    ,lp_name -- 法人姓名
    ,lp_cert_type_cd -- 法人证件类型代码
    ,lp_cert_no -- 法人证件号码
    ,lp_phone -- 法人联系电话
    ,fax -- 传真
    ,telex -- 电传
    ,rgst_addr -- 注册地址
    ,appl_dt -- 申请日期
    ,start_use_dt -- 启用日期
    ,sign_org_id -- 签约机构编号
    ,sign_netw_id -- 签约网点编号
    ,sign_dt -- 签约日期
    ,sign_teller_name -- 签约柜员名称
    ,recall_sign_dt -- 撤消签约日期
    ,recall_sign_teller_name -- 撤消签约柜员名称
    ,cust_mgr_id -- 客户经理编号
    ,mercht_belong_org_id -- 商户所属机构编号
    ,acquiri_bank_name -- 收单行名称
    ,recv_bill_brch_id -- 收单分行编号
    ,mercht_rating_calc_score -- 商户评级计算评分
    ,mercht_rating_info -- 商户评级信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_mercht_base_info_h_mrmsf1_op(
            mercht_id -- 商户编号
    ,lp_id -- 法人编号
    ,mercht_name -- 商户名称
    ,risk_lev_cd -- 风险级别代码
    ,mercht_status_cd -- 商户状态代码
    ,mercht_cn_abbr -- 商户中文简称
    ,mercht_en_name -- 商户英文名称
    ,rg_cd -- 区域代码
    ,clear_rg_cd -- 清算区域代码
    ,mercht_addr -- 商户地址
    ,corp_addr -- 公司地址
    ,mcc_code -- MCC码
    ,corp_char_cd -- 企业性质代码
    ,super_mercht_id -- 上级商户编号
    ,mercht_kind_cd -- 商户种类代码
    ,connet_way_cd -- 连接方式代码
    ,cotas_name -- 联系人姓名
    ,zip_cd -- 邮政编码
    ,cotas_e_mail -- 联系人电子邮箱
    ,cotas_tel_num -- 联系人电话号码
    ,lp_name -- 法人姓名
    ,lp_cert_type_cd -- 法人证件类型代码
    ,lp_cert_no -- 法人证件号码
    ,lp_phone -- 法人联系电话
    ,fax -- 传真
    ,telex -- 电传
    ,rgst_addr -- 注册地址
    ,appl_dt -- 申请日期
    ,start_use_dt -- 启用日期
    ,sign_org_id -- 签约机构编号
    ,sign_netw_id -- 签约网点编号
    ,sign_dt -- 签约日期
    ,sign_teller_name -- 签约柜员名称
    ,recall_sign_dt -- 撤消签约日期
    ,recall_sign_teller_name -- 撤消签约柜员名称
    ,cust_mgr_id -- 客户经理编号
    ,mercht_belong_org_id -- 商户所属机构编号
    ,acquiri_bank_name -- 收单行名称
    ,recv_bill_brch_id -- 收单分行编号
    ,mercht_rating_calc_score -- 商户评级计算评分
    ,mercht_rating_info -- 商户评级信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mercht_id -- 商户编号
    ,o.lp_id -- 法人编号
    ,o.mercht_name -- 商户名称
    ,o.risk_lev_cd -- 风险级别代码
    ,o.mercht_status_cd -- 商户状态代码
    ,o.mercht_cn_abbr -- 商户中文简称
    ,o.mercht_en_name -- 商户英文名称
    ,o.rg_cd -- 区域代码
    ,o.clear_rg_cd -- 清算区域代码
    ,o.mercht_addr -- 商户地址
    ,o.corp_addr -- 公司地址
    ,o.mcc_code -- MCC码
    ,o.corp_char_cd -- 企业性质代码
    ,o.super_mercht_id -- 上级商户编号
    ,o.mercht_kind_cd -- 商户种类代码
    ,o.connet_way_cd -- 连接方式代码
    ,o.cotas_name -- 联系人姓名
    ,o.zip_cd -- 邮政编码
    ,o.cotas_e_mail -- 联系人电子邮箱
    ,o.cotas_tel_num -- 联系人电话号码
    ,o.lp_name -- 法人姓名
    ,o.lp_cert_type_cd -- 法人证件类型代码
    ,o.lp_cert_no -- 法人证件号码
    ,o.lp_phone -- 法人联系电话
    ,o.fax -- 传真
    ,o.telex -- 电传
    ,o.rgst_addr -- 注册地址
    ,o.appl_dt -- 申请日期
    ,o.start_use_dt -- 启用日期
    ,o.sign_org_id -- 签约机构编号
    ,o.sign_netw_id -- 签约网点编号
    ,o.sign_dt -- 签约日期
    ,o.sign_teller_name -- 签约柜员名称
    ,o.recall_sign_dt -- 撤消签约日期
    ,o.recall_sign_teller_name -- 撤消签约柜员名称
    ,o.cust_mgr_id -- 客户经理编号
    ,o.mercht_belong_org_id -- 商户所属机构编号
    ,o.acquiri_bank_name -- 收单行名称
    ,o.recv_bill_brch_id -- 收单分行编号
    ,o.mercht_rating_calc_score -- 商户评级计算评分
    ,o.mercht_rating_info -- 商户评级信息
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
from ${iml_schema}.pty_mercht_base_info_h_mrmsf1_bk o
    left join ${iml_schema}.pty_mercht_base_info_h_mrmsf1_op n
        on
            o.mercht_id = n.mercht_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_mercht_base_info_h_mrmsf1_cl d
        on
            o.mercht_id = d.mercht_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_mercht_base_info_h;
--alter table ${iml_schema}.pty_mercht_base_info_h truncate partition for ('mrmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_mercht_base_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mrmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_mercht_base_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_mercht_base_info_h modify partition p_mrmsf1 
add subpartition p_mrmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_mercht_base_info_h exchange subpartition p_mrmsf1_${batch_date} with table ${iml_schema}.pty_mercht_base_info_h_mrmsf1_cl;
alter table ${iml_schema}.pty_mercht_base_info_h exchange subpartition p_mrmsf1_20991231 with table ${iml_schema}.pty_mercht_base_info_h_mrmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_mercht_base_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_mercht_base_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.pty_mercht_base_info_h_mrmsf1_op purge;
drop table ${iml_schema}.pty_mercht_base_info_h_mrmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_mercht_base_info_h_mrmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_mercht_base_info_h', partname => 'p_mrmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
