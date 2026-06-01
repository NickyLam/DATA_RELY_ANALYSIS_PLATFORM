/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_refac_loan_batch_pkg_h_icmsf1
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
alter table ${iml_schema}.agt_refac_loan_batch_pkg_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_refac_loan_batch_pkg_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_op purge;
drop table ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,batch_pkg_id -- 批次包编号
    ,batch_pkg_name -- 批次包名称
    ,batch_pkg_idf_cd -- 批次包标识代码
    ,rela_batch_pkg_name -- 关联批次包名称
    ,rela_batch_pkg_id -- 关联批次包编号
    ,use_request_descb -- 使用要求描述
    ,valid_flg -- 有效标志
    ,use_int_rat -- 使用利率
    ,int_accr_way_descb -- 计息方式描述
    ,pmo_amt_evltion_tot -- 抵质押物金额估值汇总
    ,surp_lmt -- 剩余额度
    ,cred_rht_bal -- 债权余额
    ,refac_amt -- 再贷款金额
    ,refac_distr_mode_cd -- 再贷款发放模式代码
    ,refac_kind_descb -- 专项再贷款种类代码
    ,refac_cont_id -- 再贷款合同编号
    ,refac_distr_dt -- 再贷款发放日期
    ,refac_exp_dt -- 再贷款到期日期
    ,cap_enter_acct_id -- 资金划入账户编号
    ,cap_out_acct_id -- 资金划出账户编号
    ,pbc_doc_name -- 人行文件名称
    ,pbc_lmt -- 人行额度
    ,pbc_doc_id -- 人行文件编号
    ,pbc_doc_doc_dt -- 人行文件发文日期
    ,bl_pbc_corp_princ_name -- 所属地人民银行单位负责人姓名
    ,bl_pbc_name -- 所属地人民银行名称
    ,bl_pbc_fin_inst_code -- 所属地人民银行金融机构编码
    ,bl_pbc_bond_type_descb -- 所属地人民银行债券类型描述
    ,corp_phone_num -- 单位联系电话号码
    ,corp_addr -- 单位地址
    ,move_remark -- 迁移备注
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_refac_loan_batch_pkg_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_refac_loan_batch_pkg_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_refac_loan_batch_pkg_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_zxz_package_info-1
insert into ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,batch_pkg_id -- 批次包编号
    ,batch_pkg_name -- 批次包名称
    ,batch_pkg_idf_cd -- 批次包标识代码
    ,rela_batch_pkg_name -- 关联批次包名称
    ,rela_batch_pkg_id -- 关联批次包编号
    ,use_request_descb -- 使用要求描述
    ,valid_flg -- 有效标志
    ,use_int_rat -- 使用利率
    ,int_accr_way_descb -- 计息方式描述
    ,pmo_amt_evltion_tot -- 抵质押物金额估值汇总
    ,surp_lmt -- 剩余额度
    ,cred_rht_bal -- 债权余额
    ,refac_amt -- 再贷款金额
    ,refac_distr_mode_cd -- 再贷款发放模式代码
    ,refac_kind_descb -- 专项再贷款种类代码
    ,refac_cont_id -- 再贷款合同编号
    ,refac_distr_dt -- 再贷款发放日期
    ,refac_exp_dt -- 再贷款到期日期
    ,cap_enter_acct_id -- 资金划入账户编号
    ,cap_out_acct_id -- 资金划出账户编号
    ,pbc_doc_name -- 人行文件名称
    ,pbc_lmt -- 人行额度
    ,pbc_doc_id -- 人行文件编号
    ,pbc_doc_doc_dt -- 人行文件发文日期
    ,bl_pbc_corp_princ_name -- 所属地人民银行单位负责人姓名
    ,bl_pbc_name -- 所属地人民银行名称
    ,bl_pbc_fin_inst_code -- 所属地人民银行金融机构编码
    ,bl_pbc_bond_type_descb -- 所属地人民银行债券类型描述
    ,corp_phone_num -- 单位联系电话号码
    ,corp_addr -- 单位地址
    ,move_remark -- 迁移备注
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '130023'||P1.PACKAGENO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.PACKAGENO -- 批次包编号
    ,P1.PACKAGENAME -- 批次包名称
    ,nvl(trim(P1.PACKAGEFLAG),'-') -- 批次包标识代码
    ,P1.RELPACKAGENAME -- 关联批次包名称
    ,P1.RELPACKAGENO -- 关联批次包编号
    ,P1.USEDESC -- 使用要求描述
    ,DECODE(P1.PACKAGESTATUS,'1','1','2','0',P1.PACKAGESTATUS) -- 有效标志
    ,P1.ZXZREALITYIRY -- 使用利率
    ,P1.BEARINGTYPE -- 计息方式描述
    ,P1.PLEDGESUM -- 抵质押物金额估值汇总
    ,P1.LOANBALANCE -- 剩余额度
    ,P1.CREDITORBALANCE -- 债权余额
    ,P1.APPLYAMOUNT -- 再贷款金额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.ZXZLOANMODE END -- 再贷款发放模式代码
    ,P1.LOANSTYPE -- 专项再贷款种类代码
    ,P1.ZXZCONTNO -- 再贷款合同编号
    ,P1.ZXZLOANSTARTDATE -- 再贷款发放日期
    ,P1.ZXZENDDATE -- 再贷款到期日期
    ,P1.INPUTACCOUNT -- 资金划入账户编号
    ,P1.PUTOUTACCOUNT -- 资金划出账户编号
    ,P1.BPFILENAME -- 人行文件名称
    ,P1.BPLIMIT -- 人行额度
    ,P1.BPFILENO -- 人行文件编号
    ,P1.BPFILEUSEDATE -- 人行文件发文日期
    ,P1.BELONGPBUNITLEADERNAME -- 所属地人民银行单位负责人姓名
    ,P1.BELONGPBNAME -- 所属地人民银行名称
    ,P1.BELONGPBORGID -- 所属地人民银行金融机构编码
    ,P1.CREDITORTYPE -- 所属地人民银行债券类型描述
    ,P1.UNITPHONE -- 单位联系电话号码
    ,P1.UNITADDRESS -- 单位地址
    ,P1.MIGTFLAG -- 迁移备注
    ,P1.FAILREASON -- 备注
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.INPUTORGID -- 登记机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_zxz_package_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_zxz_package_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ZXZLOANMODE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_ZXZ_PACKAGE_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'ZXZLOANMODE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_REFAC_LOAN_BATCH_PKG_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'REFAC_DISTR_MODE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,batch_pkg_id
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
        into ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,batch_pkg_id -- 批次包编号
    ,batch_pkg_name -- 批次包名称
    ,batch_pkg_idf_cd -- 批次包标识代码
    ,rela_batch_pkg_name -- 关联批次包名称
    ,rela_batch_pkg_id -- 关联批次包编号
    ,use_request_descb -- 使用要求描述
    ,valid_flg -- 有效标志
    ,use_int_rat -- 使用利率
    ,int_accr_way_descb -- 计息方式描述
    ,pmo_amt_evltion_tot -- 抵质押物金额估值汇总
    ,surp_lmt -- 剩余额度
    ,cred_rht_bal -- 债权余额
    ,refac_amt -- 再贷款金额
    ,refac_distr_mode_cd -- 再贷款发放模式代码
    ,refac_kind_descb -- 专项再贷款种类代码
    ,refac_cont_id -- 再贷款合同编号
    ,refac_distr_dt -- 再贷款发放日期
    ,refac_exp_dt -- 再贷款到期日期
    ,cap_enter_acct_id -- 资金划入账户编号
    ,cap_out_acct_id -- 资金划出账户编号
    ,pbc_doc_name -- 人行文件名称
    ,pbc_lmt -- 人行额度
    ,pbc_doc_id -- 人行文件编号
    ,pbc_doc_doc_dt -- 人行文件发文日期
    ,bl_pbc_corp_princ_name -- 所属地人民银行单位负责人姓名
    ,bl_pbc_name -- 所属地人民银行名称
    ,bl_pbc_fin_inst_code -- 所属地人民银行金融机构编码
    ,bl_pbc_bond_type_descb -- 所属地人民银行债券类型描述
    ,corp_phone_num -- 单位联系电话号码
    ,corp_addr -- 单位地址
    ,move_remark -- 迁移备注
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,batch_pkg_id -- 批次包编号
    ,batch_pkg_name -- 批次包名称
    ,batch_pkg_idf_cd -- 批次包标识代码
    ,rela_batch_pkg_name -- 关联批次包名称
    ,rela_batch_pkg_id -- 关联批次包编号
    ,use_request_descb -- 使用要求描述
    ,valid_flg -- 有效标志
    ,use_int_rat -- 使用利率
    ,int_accr_way_descb -- 计息方式描述
    ,pmo_amt_evltion_tot -- 抵质押物金额估值汇总
    ,surp_lmt -- 剩余额度
    ,cred_rht_bal -- 债权余额
    ,refac_amt -- 再贷款金额
    ,refac_distr_mode_cd -- 再贷款发放模式代码
    ,refac_kind_descb -- 专项再贷款种类代码
    ,refac_cont_id -- 再贷款合同编号
    ,refac_distr_dt -- 再贷款发放日期
    ,refac_exp_dt -- 再贷款到期日期
    ,cap_enter_acct_id -- 资金划入账户编号
    ,cap_out_acct_id -- 资金划出账户编号
    ,pbc_doc_name -- 人行文件名称
    ,pbc_lmt -- 人行额度
    ,pbc_doc_id -- 人行文件编号
    ,pbc_doc_doc_dt -- 人行文件发文日期
    ,bl_pbc_corp_princ_name -- 所属地人民银行单位负责人姓名
    ,bl_pbc_name -- 所属地人民银行名称
    ,bl_pbc_fin_inst_code -- 所属地人民银行金融机构编码
    ,bl_pbc_bond_type_descb -- 所属地人民银行债券类型描述
    ,corp_phone_num -- 单位联系电话号码
    ,corp_addr -- 单位地址
    ,move_remark -- 迁移备注
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.batch_pkg_id, o.batch_pkg_id) as batch_pkg_id -- 批次包编号
    ,nvl(n.batch_pkg_name, o.batch_pkg_name) as batch_pkg_name -- 批次包名称
    ,nvl(n.batch_pkg_idf_cd, o.batch_pkg_idf_cd) as batch_pkg_idf_cd -- 批次包标识代码
    ,nvl(n.rela_batch_pkg_name, o.rela_batch_pkg_name) as rela_batch_pkg_name -- 关联批次包名称
    ,nvl(n.rela_batch_pkg_id, o.rela_batch_pkg_id) as rela_batch_pkg_id -- 关联批次包编号
    ,nvl(n.use_request_descb, o.use_request_descb) as use_request_descb -- 使用要求描述
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.use_int_rat, o.use_int_rat) as use_int_rat -- 使用利率
    ,nvl(n.int_accr_way_descb, o.int_accr_way_descb) as int_accr_way_descb -- 计息方式描述
    ,nvl(n.pmo_amt_evltion_tot, o.pmo_amt_evltion_tot) as pmo_amt_evltion_tot -- 抵质押物金额估值汇总
    ,nvl(n.surp_lmt, o.surp_lmt) as surp_lmt -- 剩余额度
    ,nvl(n.cred_rht_bal, o.cred_rht_bal) as cred_rht_bal -- 债权余额
    ,nvl(n.refac_amt, o.refac_amt) as refac_amt -- 再贷款金额
    ,nvl(n.refac_distr_mode_cd, o.refac_distr_mode_cd) as refac_distr_mode_cd -- 再贷款发放模式代码
    ,nvl(n.refac_kind_descb, o.refac_kind_descb) as refac_kind_descb -- 专项再贷款种类代码
    ,nvl(n.refac_cont_id, o.refac_cont_id) as refac_cont_id -- 再贷款合同编号
    ,nvl(n.refac_distr_dt, o.refac_distr_dt) as refac_distr_dt -- 再贷款发放日期
    ,nvl(n.refac_exp_dt, o.refac_exp_dt) as refac_exp_dt -- 再贷款到期日期
    ,nvl(n.cap_enter_acct_id, o.cap_enter_acct_id) as cap_enter_acct_id -- 资金划入账户编号
    ,nvl(n.cap_out_acct_id, o.cap_out_acct_id) as cap_out_acct_id -- 资金划出账户编号
    ,nvl(n.pbc_doc_name, o.pbc_doc_name) as pbc_doc_name -- 人行文件名称
    ,nvl(n.pbc_lmt, o.pbc_lmt) as pbc_lmt -- 人行额度
    ,nvl(n.pbc_doc_id, o.pbc_doc_id) as pbc_doc_id -- 人行文件编号
    ,nvl(n.pbc_doc_doc_dt, o.pbc_doc_doc_dt) as pbc_doc_doc_dt -- 人行文件发文日期
    ,nvl(n.bl_pbc_corp_princ_name, o.bl_pbc_corp_princ_name) as bl_pbc_corp_princ_name -- 所属地人民银行单位负责人姓名
    ,nvl(n.bl_pbc_name, o.bl_pbc_name) as bl_pbc_name -- 所属地人民银行名称
    ,nvl(n.bl_pbc_fin_inst_code, o.bl_pbc_fin_inst_code) as bl_pbc_fin_inst_code -- 所属地人民银行金融机构编码
    ,nvl(n.bl_pbc_bond_type_descb, o.bl_pbc_bond_type_descb) as bl_pbc_bond_type_descb -- 所属地人民银行债券类型描述
    ,nvl(n.corp_phone_num, o.corp_phone_num) as corp_phone_num -- 单位联系电话号码
    ,nvl(n.corp_addr, o.corp_addr) as corp_addr -- 单位地址
    ,nvl(n.move_remark, o.move_remark) as move_remark -- 迁移备注
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.batch_pkg_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.batch_pkg_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.batch_pkg_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.batch_pkg_id = n.batch_pkg_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.batch_pkg_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.batch_pkg_id is null
    )
    or (
        o.batch_pkg_name <> n.batch_pkg_name
        or o.batch_pkg_idf_cd <> n.batch_pkg_idf_cd
        or o.rela_batch_pkg_name <> n.rela_batch_pkg_name
        or o.rela_batch_pkg_id <> n.rela_batch_pkg_id
        or o.use_request_descb <> n.use_request_descb
        or o.valid_flg <> n.valid_flg
        or o.use_int_rat <> n.use_int_rat
        or o.int_accr_way_descb <> n.int_accr_way_descb
        or o.pmo_amt_evltion_tot <> n.pmo_amt_evltion_tot
        or o.surp_lmt <> n.surp_lmt
        or o.cred_rht_bal <> n.cred_rht_bal
        or o.refac_amt <> n.refac_amt
        or o.refac_distr_mode_cd <> n.refac_distr_mode_cd
        or o.refac_kind_descb <> n.refac_kind_descb
        or o.refac_cont_id <> n.refac_cont_id
        or o.refac_distr_dt <> n.refac_distr_dt
        or o.refac_exp_dt <> n.refac_exp_dt
        or o.cap_enter_acct_id <> n.cap_enter_acct_id
        or o.cap_out_acct_id <> n.cap_out_acct_id
        or o.pbc_doc_name <> n.pbc_doc_name
        or o.pbc_lmt <> n.pbc_lmt
        or o.pbc_doc_id <> n.pbc_doc_id
        or o.pbc_doc_doc_dt <> n.pbc_doc_doc_dt
        or o.bl_pbc_corp_princ_name <> n.bl_pbc_corp_princ_name
        or o.bl_pbc_name <> n.bl_pbc_name
        or o.bl_pbc_fin_inst_code <> n.bl_pbc_fin_inst_code
        or o.bl_pbc_bond_type_descb <> n.bl_pbc_bond_type_descb
        or o.corp_phone_num <> n.corp_phone_num
        or o.corp_addr <> n.corp_addr
        or o.move_remark <> n.move_remark
        or o.remark <> n.remark
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_dt <> n.rgst_dt
        or o.rgst_org_id <> n.rgst_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,batch_pkg_id -- 批次包编号
    ,batch_pkg_name -- 批次包名称
    ,batch_pkg_idf_cd -- 批次包标识代码
    ,rela_batch_pkg_name -- 关联批次包名称
    ,rela_batch_pkg_id -- 关联批次包编号
    ,use_request_descb -- 使用要求描述
    ,valid_flg -- 有效标志
    ,use_int_rat -- 使用利率
    ,int_accr_way_descb -- 计息方式描述
    ,pmo_amt_evltion_tot -- 抵质押物金额估值汇总
    ,surp_lmt -- 剩余额度
    ,cred_rht_bal -- 债权余额
    ,refac_amt -- 再贷款金额
    ,refac_distr_mode_cd -- 再贷款发放模式代码
    ,refac_kind_descb -- 专项再贷款种类代码
    ,refac_cont_id -- 再贷款合同编号
    ,refac_distr_dt -- 再贷款发放日期
    ,refac_exp_dt -- 再贷款到期日期
    ,cap_enter_acct_id -- 资金划入账户编号
    ,cap_out_acct_id -- 资金划出账户编号
    ,pbc_doc_name -- 人行文件名称
    ,pbc_lmt -- 人行额度
    ,pbc_doc_id -- 人行文件编号
    ,pbc_doc_doc_dt -- 人行文件发文日期
    ,bl_pbc_corp_princ_name -- 所属地人民银行单位负责人姓名
    ,bl_pbc_name -- 所属地人民银行名称
    ,bl_pbc_fin_inst_code -- 所属地人民银行金融机构编码
    ,bl_pbc_bond_type_descb -- 所属地人民银行债券类型描述
    ,corp_phone_num -- 单位联系电话号码
    ,corp_addr -- 单位地址
    ,move_remark -- 迁移备注
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,batch_pkg_id -- 批次包编号
    ,batch_pkg_name -- 批次包名称
    ,batch_pkg_idf_cd -- 批次包标识代码
    ,rela_batch_pkg_name -- 关联批次包名称
    ,rela_batch_pkg_id -- 关联批次包编号
    ,use_request_descb -- 使用要求描述
    ,valid_flg -- 有效标志
    ,use_int_rat -- 使用利率
    ,int_accr_way_descb -- 计息方式描述
    ,pmo_amt_evltion_tot -- 抵质押物金额估值汇总
    ,surp_lmt -- 剩余额度
    ,cred_rht_bal -- 债权余额
    ,refac_amt -- 再贷款金额
    ,refac_distr_mode_cd -- 再贷款发放模式代码
    ,refac_kind_descb -- 专项再贷款种类代码
    ,refac_cont_id -- 再贷款合同编号
    ,refac_distr_dt -- 再贷款发放日期
    ,refac_exp_dt -- 再贷款到期日期
    ,cap_enter_acct_id -- 资金划入账户编号
    ,cap_out_acct_id -- 资金划出账户编号
    ,pbc_doc_name -- 人行文件名称
    ,pbc_lmt -- 人行额度
    ,pbc_doc_id -- 人行文件编号
    ,pbc_doc_doc_dt -- 人行文件发文日期
    ,bl_pbc_corp_princ_name -- 所属地人民银行单位负责人姓名
    ,bl_pbc_name -- 所属地人民银行名称
    ,bl_pbc_fin_inst_code -- 所属地人民银行金融机构编码
    ,bl_pbc_bond_type_descb -- 所属地人民银行债券类型描述
    ,corp_phone_num -- 单位联系电话号码
    ,corp_addr -- 单位地址
    ,move_remark -- 迁移备注
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.batch_pkg_id -- 批次包编号
    ,o.batch_pkg_name -- 批次包名称
    ,o.batch_pkg_idf_cd -- 批次包标识代码
    ,o.rela_batch_pkg_name -- 关联批次包名称
    ,o.rela_batch_pkg_id -- 关联批次包编号
    ,o.use_request_descb -- 使用要求描述
    ,o.valid_flg -- 有效标志
    ,o.use_int_rat -- 使用利率
    ,o.int_accr_way_descb -- 计息方式描述
    ,o.pmo_amt_evltion_tot -- 抵质押物金额估值汇总
    ,o.surp_lmt -- 剩余额度
    ,o.cred_rht_bal -- 债权余额
    ,o.refac_amt -- 再贷款金额
    ,o.refac_distr_mode_cd -- 再贷款发放模式代码
    ,o.refac_kind_descb -- 专项再贷款种类代码
    ,o.refac_cont_id -- 再贷款合同编号
    ,o.refac_distr_dt -- 再贷款发放日期
    ,o.refac_exp_dt -- 再贷款到期日期
    ,o.cap_enter_acct_id -- 资金划入账户编号
    ,o.cap_out_acct_id -- 资金划出账户编号
    ,o.pbc_doc_name -- 人行文件名称
    ,o.pbc_lmt -- 人行额度
    ,o.pbc_doc_id -- 人行文件编号
    ,o.pbc_doc_doc_dt -- 人行文件发文日期
    ,o.bl_pbc_corp_princ_name -- 所属地人民银行单位负责人姓名
    ,o.bl_pbc_name -- 所属地人民银行名称
    ,o.bl_pbc_fin_inst_code -- 所属地人民银行金融机构编码
    ,o.bl_pbc_bond_type_descb -- 所属地人民银行债券类型描述
    ,o.corp_phone_num -- 单位联系电话号码
    ,o.corp_addr -- 单位地址
    ,o.move_remark -- 迁移备注
    ,o.remark -- 备注
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_dt -- 登记日期
    ,o.rgst_org_id -- 登记机构编号
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
from ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_bk o
    left join ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.batch_pkg_id = n.batch_pkg_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.batch_pkg_id = d.batch_pkg_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_refac_loan_batch_pkg_h;
--alter table ${iml_schema}.agt_refac_loan_batch_pkg_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_refac_loan_batch_pkg_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_refac_loan_batch_pkg_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_refac_loan_batch_pkg_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_refac_loan_batch_pkg_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_cl;
alter table ${iml_schema}.agt_refac_loan_batch_pkg_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_refac_loan_batch_pkg_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_op purge;
drop table ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_refac_loan_batch_pkg_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_refac_loan_batch_pkg_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
