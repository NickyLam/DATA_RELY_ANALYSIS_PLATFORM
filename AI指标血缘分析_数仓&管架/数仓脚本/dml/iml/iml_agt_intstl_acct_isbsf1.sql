/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_intstl_acct_isbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_intstl_acct_isbsf1_tm purge;
drop table ${iml_schema}.agt_intstl_acct_isbsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_intstl_acct add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_intstl_acct modify partition p_isbsf1
    add subpartition p_isbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_intstl_acct_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_intstl_acct partition for ('isbsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_intstl_acct_isbsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_prior_level_cd -- 账户优先级代码
    ,acct_curr_cd -- 账户币种代码
    ,bank_acct_id -- 银行账户编号
    ,acct_bank_id -- 账户行账户编号
    ,acct_bank_name -- 账户行账户名称
    ,acct_bank_type_cd -- 账户行类型代码
    ,acct_bank_party_id -- 账户行当事人编号
    ,open_org_acct_id -- 账号开户机构账户编号
    ,open_org_acct_name -- 账号开户机构账户名称
    ,open_org_acct_type_cd -- 账号开户机构账户类型代码
    ,open_acct_org_party_id -- 账号开户机构当事人编号
    ,pos_acct_flg -- 头寸账户标志
    ,pay_back_flg -- 偿付标志
    ,del_flg -- 删除标志
    ,edit_id -- 版本编号
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,acct_bank_flg -- 账户行账号标志
    ,swift_acct_name -- SWIFT账户名称
    ,hxb_acct_flg -- 我行账户标志
    ,acct_bank_bic_code -- 账户行BIC码
    ,inter_bank_acct_id -- 国际银行账户编号
    ,enty_group_id -- 实体组编号
    ,acct_num_name_comnt -- 账号名称说明
    ,acct_usage_type_cd -- 账户用途类型代码
    ,subj_cd -- 科目代码
    ,acct_type_cd -- 账户类型代码
    ,belong_org_id -- 所属机构编号
    ,ec_idf_cd -- 钞汇标识代码
    ,prod_name -- 产品名称
    ,fori_exch_acct_char_cd -- 外汇账户性质代码
    ,std_prod_id -- 标准产品编号
    ,sub_acct_num -- 子账号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_intstl_acct
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_intstl_acct_isbsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_intstl_acct partition for ('isbsf1') where 0=1;

-- 2.1 insert data to tm table
-- isbs_act-
insert into ${iml_schema}.agt_intstl_acct_isbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_prior_level_cd -- 账户优先级代码
    ,acct_curr_cd -- 账户币种代码
    ,bank_acct_id -- 银行账户编号
    ,acct_bank_id -- 账户行账户编号
    ,acct_bank_name -- 账户行账户名称
    ,acct_bank_type_cd -- 账户行类型代码
    ,acct_bank_party_id -- 账户行当事人编号
    ,open_org_acct_id -- 账号开户机构账户编号
    ,open_org_acct_name -- 账号开户机构账户名称
    ,open_org_acct_type_cd -- 账号开户机构账户类型代码
    ,open_acct_org_party_id -- 账号开户机构当事人编号
    ,pos_acct_flg -- 头寸账户标志
    ,pay_back_flg -- 偿付标志
    ,del_flg -- 删除标志
    ,edit_id -- 版本编号
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,acct_bank_flg -- 账户行账号标志
    ,swift_acct_name -- SWIFT账户名称
    ,hxb_acct_flg -- 我行账户标志
    ,acct_bank_bic_code -- 账户行BIC码
    ,inter_bank_acct_id -- 国际银行账户编号
    ,enty_group_id -- 实体组编号
    ,acct_num_name_comnt -- 账号名称说明
    ,acct_usage_type_cd -- 账户用途类型代码
    ,subj_cd -- 科目代码
    ,acct_type_cd -- 账户类型代码
    ,belong_org_id -- 所属机构编号
    ,ec_idf_cd -- 钞汇标识代码
    ,prod_name -- 产品名称
    ,fori_exch_acct_char_cd -- 外汇账户性质代码
    ,std_prod_id -- 标准产品编号
    ,sub_acct_num -- 子账号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '130015'|| P1.INR -- 协议编号
    ,'9999' -- 法人编号
    ,P1.PRI -- 账户优先级代码
    ,P1.CUR -- 账户币种代码
    ,P1.EXTKEY -- 银行账户编号
    ,P1.SERACC -- 账户行账户编号
    ,P1.SERNAM -- 账户行账户名称
    ,P1.SERPTYTYP -- 账户行类型代码
    ,P1.SERPTYINR -- 账户行当事人编号
    ,P1.HOLACC -- 账号开户机构账户编号
    ,P1.HOLACC -- 账号开户机构账户名称
    ,P1.HOLPTYTYP -- 账号开户机构账户类型代码
    ,P1.HOLPTYINR -- 账号开户机构当事人编号
    ,case when R6.TARGET_CD_VAL is not null then R6.TARGET_CD_VAL else '@'|| P1.CVRFLG end  -- 头寸账户标志
    ,case when R2.TARGET_CD_VAL is not null then R2.TARGET_CD_VAL else '@'|| P1.RMBFLG end  -- 偿付标志
    ,case when R3.TARGET_CD_VAL is not null then R3.TARGET_CD_VAL else '@'|| P1.DELFLG end  -- 删除标志
    ,P1.VER -- 版本编号
    ,case when R4.TARGET_CD_VAL is not null then R4.TARGET_CD_VAL else '@'|| P1.DIRFLG end  -- 借贷方向代码
    ,case when trim(P1.OTHBNKFLG) is not null then '1' else '0' end -- 账户行账号标志
    ,P1.OTHPTYNAM -- SWIFT账户名称
    ,case when trim(P1.OTHOWNFLG) is not null then '1' else '0' end -- 我行账户标志
    ,P1.OTHBIC6 -- 账户行BIC码
    ,P1.IBAN -- 国际银行账户编号
    ,P1.ETGEXTKEY -- 实体组编号
    ,P1.NAM -- 账号名称说明
    ,P1.TYP -- 账户用途类型代码
    ,P1.TRMTYP -- 科目代码
    ,case when R5.TARGET_CD_VAL is not null then R5.TARGET_CD_VAL else '@'|| P1.ACCTYP end  -- 账户类型代码
    ,P1.BCHKEYINR -- 所属机构编号
    ,nvl(trim(P1.CSHFLG),'-') -- 钞汇标识代码
    ,P1.NAM1 -- 产品名称
    ,nvl(trim(P1.WGZHXZ),'0000') -- 外汇账户性质代码
    ,P1.PRDTYP -- 标准产品编号
    ,P1.SEQNO -- 子账号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_act' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_act p1
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.CVRFLG=R6.SRC_CODE_VAL
AND R6.SORC_SYS_CD='ISBS'
AND R6.SRC_TAB_EN_NAME='ISBS_ACT'
AND R6.SRC_FIELD_EN_NAME='CVRFLG'
AND R6.TARGET_TAB_EN_NAME='AGT_INTSTL_ACCT'
AND R6.TARGET_TAB_FIELD_EN_NAME='POS_ACCT_FLG'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.RMBFLG=R2.SRC_CODE_VAL
AND R2.SORC_SYS_CD='ISBS'
AND R2.SRC_TAB_EN_NAME='ISBS_ACT'
AND R2.SRC_FIELD_EN_NAME='RMBFLG'
AND R2.TARGET_TAB_EN_NAME='AGT_INTSTL_ACCT'
AND R2.TARGET_TAB_FIELD_EN_NAME='PAY_BACK_FLG'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.DELFLG=R3.SRC_CODE_VAL
AND R3.SORC_SYS_CD='ISBS'
AND R3.SRC_TAB_EN_NAME='ISBS_ACT'
AND R3.SRC_FIELD_EN_NAME='DELFLG'
AND R3.TARGET_TAB_EN_NAME='AGT_INTSTL_ACCT'
AND R3.TARGET_TAB_FIELD_EN_NAME='DEL_FLG'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.DIRFLG=R4.SRC_CODE_VAL
AND R4.SORC_SYS_CD='ISBS'
AND R4.SRC_TAB_EN_NAME='ISBS_ACT'
AND R4.SRC_FIELD_EN_NAME='DIRFLG'
AND R4.TARGET_TAB_EN_NAME='AGT_INTSTL_ACCT'
AND R4.TARGET_TAB_FIELD_EN_NAME='DEBIT_CRDT_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.ACCTYP=R5.SRC_CODE_VAL
AND R5.SORC_SYS_CD='ISBS'
AND R5.SRC_TAB_EN_NAME='ISBS_ACT'
AND R5.SRC_FIELD_EN_NAME='ACCTYP'
AND R5.TARGET_TAB_EN_NAME='AGT_INTSTL_ACCT'
AND R5.TARGET_TAB_FIELD_EN_NAME='ACCT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_intstl_acct_isbsf1_tm 
  	                                group by 
  	                                        agt_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_intstl_acct_isbsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_prior_level_cd -- 账户优先级代码
    ,acct_curr_cd -- 账户币种代码
    ,bank_acct_id -- 银行账户编号
    ,acct_bank_id -- 账户行账户编号
    ,acct_bank_name -- 账户行账户名称
    ,acct_bank_type_cd -- 账户行类型代码
    ,acct_bank_party_id -- 账户行当事人编号
    ,open_org_acct_id -- 账号开户机构账户编号
    ,open_org_acct_name -- 账号开户机构账户名称
    ,open_org_acct_type_cd -- 账号开户机构账户类型代码
    ,open_acct_org_party_id -- 账号开户机构当事人编号
    ,pos_acct_flg -- 头寸账户标志
    ,pay_back_flg -- 偿付标志
    ,del_flg -- 删除标志
    ,edit_id -- 版本编号
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,acct_bank_flg -- 账户行账号标志
    ,swift_acct_name -- SWIFT账户名称
    ,hxb_acct_flg -- 我行账户标志
    ,acct_bank_bic_code -- 账户行BIC码
    ,inter_bank_acct_id -- 国际银行账户编号
    ,enty_group_id -- 实体组编号
    ,acct_num_name_comnt -- 账号名称说明
    ,acct_usage_type_cd -- 账户用途类型代码
    ,subj_cd -- 科目代码
    ,acct_type_cd -- 账户类型代码
    ,belong_org_id -- 所属机构编号
    ,ec_idf_cd -- 钞汇标识代码
    ,prod_name -- 产品名称
    ,fori_exch_acct_char_cd -- 外汇账户性质代码
    ,std_prod_id -- 标准产品编号
    ,sub_acct_num -- 子账号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.acct_prior_level_cd, o.acct_prior_level_cd) as acct_prior_level_cd -- 账户优先级代码
    ,nvl(n.acct_curr_cd, o.acct_curr_cd) as acct_curr_cd -- 账户币种代码
    ,nvl(n.bank_acct_id, o.bank_acct_id) as bank_acct_id -- 银行账户编号
    ,nvl(n.acct_bank_id, o.acct_bank_id) as acct_bank_id -- 账户行账户编号
    ,nvl(n.acct_bank_name, o.acct_bank_name) as acct_bank_name -- 账户行账户名称
    ,nvl(n.acct_bank_type_cd, o.acct_bank_type_cd) as acct_bank_type_cd -- 账户行类型代码
    ,nvl(n.acct_bank_party_id, o.acct_bank_party_id) as acct_bank_party_id -- 账户行当事人编号
    ,nvl(n.open_org_acct_id, o.open_org_acct_id) as open_org_acct_id -- 账号开户机构账户编号
    ,nvl(n.open_org_acct_name, o.open_org_acct_name) as open_org_acct_name -- 账号开户机构账户名称
    ,nvl(n.open_org_acct_type_cd, o.open_org_acct_type_cd) as open_org_acct_type_cd -- 账号开户机构账户类型代码
    ,nvl(n.open_acct_org_party_id, o.open_acct_org_party_id) as open_acct_org_party_id -- 账号开户机构当事人编号
    ,nvl(n.pos_acct_flg, o.pos_acct_flg) as pos_acct_flg -- 头寸账户标志
    ,nvl(n.pay_back_flg, o.pay_back_flg) as pay_back_flg -- 偿付标志
    ,nvl(n.del_flg, o.del_flg) as del_flg -- 删除标志
    ,nvl(n.edit_id, o.edit_id) as edit_id -- 版本编号
    ,nvl(n.debit_crdt_dir_cd, o.debit_crdt_dir_cd) as debit_crdt_dir_cd -- 借贷方向代码
    ,nvl(n.acct_bank_flg, o.acct_bank_flg) as acct_bank_flg -- 账户行账号标志
    ,nvl(n.swift_acct_name, o.swift_acct_name) as swift_acct_name -- SWIFT账户名称
    ,nvl(n.hxb_acct_flg, o.hxb_acct_flg) as hxb_acct_flg -- 我行账户标志
    ,nvl(n.acct_bank_bic_code, o.acct_bank_bic_code) as acct_bank_bic_code -- 账户行BIC码
    ,nvl(n.inter_bank_acct_id, o.inter_bank_acct_id) as inter_bank_acct_id -- 国际银行账户编号
    ,nvl(n.enty_group_id, o.enty_group_id) as enty_group_id -- 实体组编号
    ,nvl(n.acct_num_name_comnt, o.acct_num_name_comnt) as acct_num_name_comnt -- 账号名称说明
    ,nvl(n.acct_usage_type_cd, o.acct_usage_type_cd) as acct_usage_type_cd -- 账户用途类型代码
    ,nvl(n.subj_cd, o.subj_cd) as subj_cd -- 科目代码
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.ec_idf_cd, o.ec_idf_cd) as ec_idf_cd -- 钞汇标识代码
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.fori_exch_acct_char_cd, o.fori_exch_acct_char_cd) as fori_exch_acct_char_cd -- 外汇账户性质代码
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.acct_prior_level_cd <> n.acct_prior_level_cd
                or o.acct_curr_cd <> n.acct_curr_cd
                or o.bank_acct_id <> n.bank_acct_id
                or o.acct_bank_id <> n.acct_bank_id
                or o.acct_bank_name <> n.acct_bank_name
                or o.acct_bank_type_cd <> n.acct_bank_type_cd
                or o.acct_bank_party_id <> n.acct_bank_party_id
                or o.open_org_acct_id <> n.open_org_acct_id
                or o.open_org_acct_name <> n.open_org_acct_name
                or o.open_org_acct_type_cd <> n.open_org_acct_type_cd
                or o.open_acct_org_party_id <> n.open_acct_org_party_id
                or o.pos_acct_flg <> n.pos_acct_flg
                or o.pay_back_flg <> n.pay_back_flg
                or o.del_flg <> n.del_flg
                or o.edit_id <> n.edit_id
                or o.debit_crdt_dir_cd <> n.debit_crdt_dir_cd
                or o.acct_bank_flg <> n.acct_bank_flg
                or o.swift_acct_name <> n.swift_acct_name
                or o.hxb_acct_flg <> n.hxb_acct_flg
                or o.acct_bank_bic_code <> n.acct_bank_bic_code
                or o.inter_bank_acct_id <> n.inter_bank_acct_id
                or o.enty_group_id <> n.enty_group_id
                or o.acct_num_name_comnt <> n.acct_num_name_comnt
                or o.acct_usage_type_cd <> n.acct_usage_type_cd
                or o.subj_cd <> n.subj_cd
                or o.acct_type_cd <> n.acct_type_cd
                or o.belong_org_id <> n.belong_org_id
                or o.ec_idf_cd <> n.ec_idf_cd
                or o.prod_name <> n.prod_name
                or o.fori_exch_acct_char_cd <> n.fori_exch_acct_char_cd
                or o.std_prod_id <> n.std_prod_id
                or o.sub_acct_num <> n.sub_acct_num
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_intstl_acct_isbsf1_tm n
    full join ${iml_schema}.agt_intstl_acct_isbsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_intstl_acct truncate partition for ('isbsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_intstl_acct exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.agt_intstl_acct_isbsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_intstl_acct drop subpartition p_isbsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_intstl_acct to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_intstl_acct_isbsf1_tm purge;
drop table ${iml_schema}.agt_intstl_acct_isbsf1_ex purge;
drop table ${iml_schema}.agt_intstl_acct_isbsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_intstl_acct', partname => 'p_isbsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);