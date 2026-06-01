/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_eacct
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
alter table ${idl_schema}.oass_agt_eacct drop partition p_${retain_week};
alter table ${idl_schema}.oass_agt_eacct drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_eacct add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_eacct (
    etl_dt  -- 数据日期
    ,agt_id  -- 协议编号
    ,lp_id  -- 法人编号
    ,acct_id  -- 账户编号
    ,acct_name  -- 账户名称
    ,open_acct_tm  -- 开户时间
    ,clos_acct_tm  -- 销户时间
    ,eacct_id  -- E账户编号
    ,cust_id  -- 客户编号
    ,open_acct_org_id  -- 开户机构编号
    ,vouch_id  -- 凭证编号
    ,vouch_status_cd  -- 凭证状态代码
    ,acct_status_cd  -- 账户状态代码
    ,tran_chn_status_cd  -- 交易渠道状态代码
    ,froz_status_cd  -- 冻结状态代码
    ,vrif_status_cd  -- 核实状态代码
    ,curr_cd  -- 币种代码
    ,eacct_level_cd  -- E账户等级代码
    ,netw_vrfction_rest_cd  -- 联网核查结果代码
    ,open_acct_chn_cd  -- 开户渠道代码
    ,tran_chn_status_modif_org_id  -- 交易渠道状态变更机构编号
    ,acct_type_cd  -- 账户类型代码
    ,acct_level_cd  -- 账户等级代码
    ,sav_type_cd  -- 储种代码
    ,tran_kind_cd  -- 交易种类代码
    ,prvy_acct_flg  -- 私密账户标志
    ,drawdown_way_cd  -- 支取方式代码
    ,vouch_kind_cd  -- 凭证种类代码
    ,cust_lev_cd  -- 客户级别代码
    ,acct_orgnz_form_cd  -- 账户组织形式代码
    ,ec_idf_cd  -- 钞汇标识代码
    ,cross_tx_cd  -- 通存通兑代码
    ,chip_card_cd  -- 芯片卡代码
    ,co_card_type_cd  -- 合作卡类型代码
    ,blip_retnd_cd  -- 影像留存代码
    ,real_name_cert_cd  -- 实名认证代码
    ,bus_type_cd  -- 业务类型代码
    ,legal_flg  -- 涉案标志
    ,legal_tm  -- 涉案时间
    ,mercht_id  -- 商户编号
    ,mercht_name  -- 商户名称
    ,non_bind_enter_acct_flg  -- 非绑定账户入账标志
    ,sleep_acct_flg  -- 睡眠户标志
    ,descb  -- 描述
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.agt_id,chr(13),''),chr(10),'')  -- 协议编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.acct_id,chr(13),''),chr(10),'')  -- 账户编号
    ,replace(replace(t1.acct_name,chr(13),''),chr(10),'')  -- 账户名称
    ,t1.open_acct_tm  -- 开户时间
    ,t1.clos_acct_tm  -- 销户时间
    ,replace(replace(t1.eacct_id,chr(13),''),chr(10),'')  -- E账户编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'')  -- 开户机构编号
    ,replace(replace(t1.vouch_id,chr(13),''),chr(10),'')  -- 凭证编号
    ,replace(replace(t1.vouch_status_cd,chr(13),''),chr(10),'')  -- 凭证状态代码
    ,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'')  -- 账户状态代码
    ,replace(replace(t1.tran_chn_status_cd,chr(13),''),chr(10),'')  -- 交易渠道状态代码
    ,replace(replace(t1.froz_status_cd,chr(13),''),chr(10),'')  -- 冻结状态代码
    ,replace(replace(t1.vrif_status_cd,chr(13),''),chr(10),'')  -- 核实状态代码
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.eacct_level_cd,chr(13),''),chr(10),'')  -- E账户等级代码
    ,replace(replace(t1.netw_vrfction_rest_cd,chr(13),''),chr(10),'')  -- 联网核查结果代码
    ,replace(replace(t1.open_acct_chn_cd,chr(13),''),chr(10),'')  -- 开户渠道代码
    ,replace(replace(t1.tran_chn_status_modif_org_id,chr(13),''),chr(10),'')  -- 交易渠道状态变更机构编号
    ,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'')  -- 账户类型代码
    ,replace(replace(t1.acct_level_cd,chr(13),''),chr(10),'')  -- 账户等级代码
    ,replace(replace(t1.sav_type_cd,chr(13),''),chr(10),'')  -- 储种代码
    ,replace(replace(t1.tran_kind_cd,chr(13),''),chr(10),'')  -- 交易种类代码
    ,replace(replace(t1.prvy_acct_flg,chr(13),''),chr(10),'')  -- 私密账户标志
    ,replace(replace(t1.drawdown_way_cd,chr(13),''),chr(10),'')  -- 支取方式代码
    ,replace(replace(t1.vouch_kind_cd,chr(13),''),chr(10),'')  -- 凭证种类代码
    ,replace(replace(t1.cust_lev_cd,chr(13),''),chr(10),'')  -- 客户级别代码
    ,replace(replace(t1.acct_orgnz_form_cd,chr(13),''),chr(10),'')  -- 账户组织形式代码
    ,replace(replace(t1.ec_idf_cd,chr(13),''),chr(10),'')  -- 钞汇标识代码
    ,replace(replace(t1.cross_tx_cd,chr(13),''),chr(10),'')  -- 通存通兑代码
    ,replace(replace(t1.chip_card_cd,chr(13),''),chr(10),'')  -- 芯片卡代码
    ,replace(replace(t1.co_card_type_cd,chr(13),''),chr(10),'')  -- 合作卡类型代码
    ,replace(replace(t1.blip_retnd_cd,chr(13),''),chr(10),'')  -- 影像留存代码
    ,replace(replace(t1.real_name_cert_cd,chr(13),''),chr(10),'')  -- 实名认证代码
    ,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'')  -- 业务类型代码
    ,replace(replace(t1.legal_flg,chr(13),''),chr(10),'')  -- 涉案标志
    ,t1.legal_tm  -- 涉案时间
    ,replace(replace(t1.mercht_id,chr(13),''),chr(10),'')  -- 商户编号
    ,replace(replace(t1.mercht_name,chr(13),''),chr(10),'')  -- 商户名称
    ,replace(replace(t1.non_bind_enter_acct_flg,chr(13),''),chr(10),'')  -- 非绑定账户入账标志
    ,replace(replace(t1.sleep_acct_flg,chr(13),''),chr(10),'')  -- 睡眠户标志
    ,replace(replace(t1.descb,chr(13),''),chr(10),'')  -- 描述
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码
from ${iml_schema}.agt_eacct t1    --oass_agt_eacct
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_eacct',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);