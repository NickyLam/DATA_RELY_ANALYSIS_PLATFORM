/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_cust_rela_party_info_h_icmsf1
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
alter table ${iml_schema}.pty_cust_rela_party_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cust_rela_party_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_op purge;
drop table ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,main_cust_id -- 主客户编号
    ,rela_ps_cust_id -- 关联人客户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_name -- 当事人名称
    ,party_rela_type_cd -- 关联关系类型代码
    ,legal_rep_name -- 法人代表名称
    ,rela_party_loan_card_no -- 关联方贷款卡号
    ,rela_setup_dt -- 关系建立日期
    ,sup_prod_name -- 供应产品名称
    ,sup_curr_cd -- 供应币种代码
    ,sup_amt -- 供应金额
    ,sup_ratio -- 供应比例
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_sup_chain_client_bs_id -- 所属供应链客户群编号
    ,co_years -- 合作年限
    ,stl_way_cd -- 结算方式代码
    ,org_crdt_id -- 机构信用编号
    ,stru_rela_party_reason_descb -- 构成关联方理由描述
    ,hxb_rela_corp_flg -- 我行关联企业标志
    ,can_sup_prod_descb -- 可供应产品描述
    ,move_flg -- 迁移标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cust_rela_party_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cust_rela_party_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cust_rela_party_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_customer_ship_related-1
insert into ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,main_cust_id -- 主客户编号
    ,rela_ps_cust_id -- 关联人客户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_name -- 当事人名称
    ,party_rela_type_cd -- 关联关系类型代码
    ,legal_rep_name -- 法人代表名称
    ,rela_party_loan_card_no -- 关联方贷款卡号
    ,rela_setup_dt -- 关系建立日期
    ,sup_prod_name -- 供应产品名称
    ,sup_curr_cd -- 供应币种代码
    ,sup_amt -- 供应金额
    ,sup_ratio -- 供应比例
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_sup_chain_client_bs_id -- 所属供应链客户群编号
    ,co_years -- 合作年限
    ,stl_way_cd -- 结算方式代码
    ,org_crdt_id -- 机构信用编号
    ,stru_rela_party_reason_descb -- 构成关联方理由描述
    ,hxb_rela_corp_flg -- 我行关联企业标志
    ,can_sup_prod_descb -- 可供应产品描述
    ,move_flg -- 迁移标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p1.SERIALNO -- 当事人编号
    , '9999' -- 法人编号
    ,P1.MAINCUSTOMERID -- 主客户编号
    ,P1.CUSTOMERID -- 关联人客户编号
    ,nvl(trim(P1.CERTTYPE),'0000') -- 证件类型代码
    ,p1.CERTID -- 证件号码
    ,p1.CUSTOMERNAME -- 当事人名称
    ,nvl(trim(P1.RELATIONSHIP),'00000') -- 关联关系类型代码
    ,p1.LEGALNAME -- 法人代表名称
    ,p1.LOANCARDNO -- 关联方贷款卡号
    ,p1.INVESTDATE -- 关系建立日期
    ,p1.SUPPLYNAME -- 供应产品名称
    ,p1.SUPPLYCURRENCY -- 供应币种代码
    ,p1.SUPPLYVALUE -- 供应金额
    ,p1.SUPPLYPROP -- 供应比例
    ,p1.REMARK -- 备注
    ,p1.INPUTUSERID -- 登记柜员编号
    ,p1.INPUTDATE -- 登记日期
    ,p1.INPUTORGID -- 登记机构编号
    ,p1.UPDATEUSERID -- 更新柜员编号
    ,p1.UPDATEORGID -- 更新机构编号
    ,p1.UPDATEDATE -- 变更日期
    ,p1.GROUPID -- 所属供应链客户群编号
    ,p1.COMOPERIATIONYEAR -- 合作年限
    ,p1.SETTLENENTMODE -- 结算方式代码
    ,p1.CREDITINSTITUTIONCODE -- 机构信用编号
    ,p1.DESCRIBE -- 构成关联方理由描述
    ,p1.ISAFFENTERPRISES -- 我行关联企业标志
    ,p1.PRODUCTION -- 可供应产品描述
    ,CASE WHEN TRIM(P1.MIGTFLAG) IS NOT NULL THEN '1' ELSE '0' END -- 迁移标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_customer_ship_related' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_customer_ship_related p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_tm 
  	                                group by 
  	                                        party_id
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
        into ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,main_cust_id -- 主客户编号
    ,rela_ps_cust_id -- 关联人客户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_name -- 当事人名称
    ,party_rela_type_cd -- 关联关系类型代码
    ,legal_rep_name -- 法人代表名称
    ,rela_party_loan_card_no -- 关联方贷款卡号
    ,rela_setup_dt -- 关系建立日期
    ,sup_prod_name -- 供应产品名称
    ,sup_curr_cd -- 供应币种代码
    ,sup_amt -- 供应金额
    ,sup_ratio -- 供应比例
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_sup_chain_client_bs_id -- 所属供应链客户群编号
    ,co_years -- 合作年限
    ,stl_way_cd -- 结算方式代码
    ,org_crdt_id -- 机构信用编号
    ,stru_rela_party_reason_descb -- 构成关联方理由描述
    ,hxb_rela_corp_flg -- 我行关联企业标志
    ,can_sup_prod_descb -- 可供应产品描述
    ,move_flg -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,main_cust_id -- 主客户编号
    ,rela_ps_cust_id -- 关联人客户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_name -- 当事人名称
    ,party_rela_type_cd -- 关联关系类型代码
    ,legal_rep_name -- 法人代表名称
    ,rela_party_loan_card_no -- 关联方贷款卡号
    ,rela_setup_dt -- 关系建立日期
    ,sup_prod_name -- 供应产品名称
    ,sup_curr_cd -- 供应币种代码
    ,sup_amt -- 供应金额
    ,sup_ratio -- 供应比例
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_sup_chain_client_bs_id -- 所属供应链客户群编号
    ,co_years -- 合作年限
    ,stl_way_cd -- 结算方式代码
    ,org_crdt_id -- 机构信用编号
    ,stru_rela_party_reason_descb -- 构成关联方理由描述
    ,hxb_rela_corp_flg -- 我行关联企业标志
    ,can_sup_prod_descb -- 可供应产品描述
    ,move_flg -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.main_cust_id, o.main_cust_id) as main_cust_id -- 主客户编号
    ,nvl(n.rela_ps_cust_id, o.rela_ps_cust_id) as rela_ps_cust_id -- 关联人客户编号
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.party_name, o.party_name) as party_name -- 当事人名称
    ,nvl(n.party_rela_type_cd, o.party_rela_type_cd) as party_rela_type_cd -- 关联关系类型代码
    ,nvl(n.legal_rep_name, o.legal_rep_name) as legal_rep_name -- 法人代表名称
    ,nvl(n.rela_party_loan_card_no, o.rela_party_loan_card_no) as rela_party_loan_card_no -- 关联方贷款卡号
    ,nvl(n.rela_setup_dt, o.rela_setup_dt) as rela_setup_dt -- 关系建立日期
    ,nvl(n.sup_prod_name, o.sup_prod_name) as sup_prod_name -- 供应产品名称
    ,nvl(n.sup_curr_cd, o.sup_curr_cd) as sup_curr_cd -- 供应币种代码
    ,nvl(n.sup_amt, o.sup_amt) as sup_amt -- 供应金额
    ,nvl(n.sup_ratio, o.sup_ratio) as sup_ratio -- 供应比例
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,nvl(n.belong_sup_chain_client_bs_id, o.belong_sup_chain_client_bs_id) as belong_sup_chain_client_bs_id -- 所属供应链客户群编号
    ,nvl(n.co_years, o.co_years) as co_years -- 合作年限
    ,nvl(n.stl_way_cd, o.stl_way_cd) as stl_way_cd -- 结算方式代码
    ,nvl(n.org_crdt_id, o.org_crdt_id) as org_crdt_id -- 机构信用编号
    ,nvl(n.stru_rela_party_reason_descb, o.stru_rela_party_reason_descb) as stru_rela_party_reason_descb -- 构成关联方理由描述
    ,nvl(n.hxb_rela_corp_flg, o.hxb_rela_corp_flg) as hxb_rela_corp_flg -- 我行关联企业标志
    ,nvl(n.can_sup_prod_descb, o.can_sup_prod_descb) as can_sup_prod_descb -- 可供应产品描述
    ,nvl(n.move_flg, o.move_flg) as move_flg -- 迁移标志
    ,case when
            n.party_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
where (
        o.party_id is null
        and o.lp_id is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
    )
    or (
        o.main_cust_id <> n.main_cust_id
        or o.rela_ps_cust_id <> n.rela_ps_cust_id
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.party_name <> n.party_name
        or o.party_rela_type_cd <> n.party_rela_type_cd
        or o.legal_rep_name <> n.legal_rep_name
        or o.rela_party_loan_card_no <> n.rela_party_loan_card_no
        or o.rela_setup_dt <> n.rela_setup_dt
        or o.sup_prod_name <> n.sup_prod_name
        or o.sup_curr_cd <> n.sup_curr_cd
        or o.sup_amt <> n.sup_amt
        or o.sup_ratio <> n.sup_ratio
        or o.remark <> n.remark
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_dt <> n.rgst_dt
        or o.rgst_org_id <> n.rgst_org_id
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.modif_dt <> n.modif_dt
        or o.belong_sup_chain_client_bs_id <> n.belong_sup_chain_client_bs_id
        or o.co_years <> n.co_years
        or o.stl_way_cd <> n.stl_way_cd
        or o.org_crdt_id <> n.org_crdt_id
        or o.stru_rela_party_reason_descb <> n.stru_rela_party_reason_descb
        or o.hxb_rela_corp_flg <> n.hxb_rela_corp_flg
        or o.can_sup_prod_descb <> n.can_sup_prod_descb
        or o.move_flg <> n.move_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,main_cust_id -- 主客户编号
    ,rela_ps_cust_id -- 关联人客户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_name -- 当事人名称
    ,party_rela_type_cd -- 关联关系类型代码
    ,legal_rep_name -- 法人代表名称
    ,rela_party_loan_card_no -- 关联方贷款卡号
    ,rela_setup_dt -- 关系建立日期
    ,sup_prod_name -- 供应产品名称
    ,sup_curr_cd -- 供应币种代码
    ,sup_amt -- 供应金额
    ,sup_ratio -- 供应比例
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_sup_chain_client_bs_id -- 所属供应链客户群编号
    ,co_years -- 合作年限
    ,stl_way_cd -- 结算方式代码
    ,org_crdt_id -- 机构信用编号
    ,stru_rela_party_reason_descb -- 构成关联方理由描述
    ,hxb_rela_corp_flg -- 我行关联企业标志
    ,can_sup_prod_descb -- 可供应产品描述
    ,move_flg -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,main_cust_id -- 主客户编号
    ,rela_ps_cust_id -- 关联人客户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_name -- 当事人名称
    ,party_rela_type_cd -- 关联关系类型代码
    ,legal_rep_name -- 法人代表名称
    ,rela_party_loan_card_no -- 关联方贷款卡号
    ,rela_setup_dt -- 关系建立日期
    ,sup_prod_name -- 供应产品名称
    ,sup_curr_cd -- 供应币种代码
    ,sup_amt -- 供应金额
    ,sup_ratio -- 供应比例
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_sup_chain_client_bs_id -- 所属供应链客户群编号
    ,co_years -- 合作年限
    ,stl_way_cd -- 结算方式代码
    ,org_crdt_id -- 机构信用编号
    ,stru_rela_party_reason_descb -- 构成关联方理由描述
    ,hxb_rela_corp_flg -- 我行关联企业标志
    ,can_sup_prod_descb -- 可供应产品描述
    ,move_flg -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.main_cust_id -- 主客户编号
    ,o.rela_ps_cust_id -- 关联人客户编号
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.party_name -- 当事人名称
    ,o.party_rela_type_cd -- 关联关系类型代码
    ,o.legal_rep_name -- 法人代表名称
    ,o.rela_party_loan_card_no -- 关联方贷款卡号
    ,o.rela_setup_dt -- 关系建立日期
    ,o.sup_prod_name -- 供应产品名称
    ,o.sup_curr_cd -- 供应币种代码
    ,o.sup_amt -- 供应金额
    ,o.sup_ratio -- 供应比例
    ,o.remark -- 备注
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_dt -- 登记日期
    ,o.rgst_org_id -- 登记机构编号
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.modif_dt -- 变更日期
    ,o.belong_sup_chain_client_bs_id -- 所属供应链客户群编号
    ,o.co_years -- 合作年限
    ,o.stl_way_cd -- 结算方式代码
    ,o.org_crdt_id -- 机构信用编号
    ,o.stru_rela_party_reason_descb -- 构成关联方理由描述
    ,o.hxb_rela_corp_flg -- 我行关联企业标志
    ,o.can_sup_prod_descb -- 可供应产品描述
    ,o.move_flg -- 迁移标志
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
from ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_bk o
    left join ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_cust_rela_party_info_h;
--alter table ${iml_schema}.pty_cust_rela_party_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_cust_rela_party_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_cust_rela_party_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_cust_rela_party_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_cust_rela_party_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_cl;
alter table ${iml_schema}.pty_cust_rela_party_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_cust_rela_party_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_op purge;
drop table ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_cust_rela_party_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_cust_rela_party_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
