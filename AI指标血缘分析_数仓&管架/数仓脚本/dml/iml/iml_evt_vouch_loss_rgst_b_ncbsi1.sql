/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_vouch_loss_rgst_b_ncbsi1
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
drop table ${iml_schema}.evt_vouch_loss_rgst_b_ncbsi1_tm purge;
alter table ${iml_schema}.evt_vouch_loss_rgst_b add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_vouch_loss_rgst_b modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_vouch_loss_rgst_b_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,loss_idf -- 挂失标识符
    ,loss_id -- 挂失编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,cust_acct_num -- 客户账号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,vouch_loss_cate_cd -- 凭证挂失类别代码
    ,vouch_loss_status_cd -- 凭证挂失状态代码
    ,froz_start_seq_num -- 冻结开始序号
    ,vouch_tran_froz_flg -- 凭证交易冻结标志
    ,tran_ref_no -- 交易参考号
    ,chn_id -- 渠道编号
    ,loss_unloss_rs -- 挂失解挂原因
    ,unloss_type_cd -- 解挂类型代码
    ,unloss_dt -- 解挂日期
    ,unloss_org_id -- 解挂机构编号
    ,unloss_auth_teller_id -- 解挂授权柜员编号
    ,unloss_teller_id -- 解挂柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,rest_descb -- 处理结果描述
    ,dfoget_pwd_flg -- 忘记密码标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_vouch_loss_rgst_b
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_voucher_lost-1
insert into ${iml_schema}.evt_vouch_loss_rgst_b_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,loss_idf -- 挂失标识符
    ,loss_id -- 挂失编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,cust_acct_num -- 客户账号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,vouch_loss_cate_cd -- 凭证挂失类别代码
    ,vouch_loss_status_cd -- 凭证挂失状态代码
    ,froz_start_seq_num -- 冻结开始序号
    ,vouch_tran_froz_flg -- 凭证交易冻结标志
    ,tran_ref_no -- 交易参考号
    ,chn_id -- 渠道编号
    ,loss_unloss_rs -- 挂失解挂原因
    ,unloss_type_cd -- 解挂类型代码
    ,unloss_dt -- 解挂日期
    ,unloss_org_id -- 解挂机构编号
    ,unloss_auth_teller_id -- 解挂授权柜员编号
    ,unloss_teller_id -- 解挂柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,rest_descb -- 处理结果描述
    ,dfoget_pwd_flg -- 忘记密码标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101046'||P1.LOST_KEY||P1.LOST_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.LOST_KEY -- 挂失标识符
    ,P1.LOST_NO -- 挂失编号
    ,P1.TRAN_DATE -- 交易日期
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.ACCT_CCY -- 账户币种代码
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.CLIENT_NO -- 客户编号
    ,P1.DOC_TYPE -- 存款凭证类别代码
    ,P1.VOUCHER_NO -- 凭证号码
    ,P1.LOST_TYPE -- 凭证挂失类别代码
    ,P1.VOUCHER_LOST_STATUS -- 凭证挂失状态代码
    ,P1.START_SEQ_NO -- 冻结开始序号
    ,DECODE(P1.RES_FLAG,'Y','1','N','0') -- 凭证交易冻结标志
    ,P1.REFERENCE -- 交易参考号
    ,P1.SOURCE_TYPE -- 渠道编号
    ,P1.REPORTED_LOST_REASON -- 挂失解挂原因
    ,nvl(trim(P1.RELIEVE_LOSS_TYPE),'-') -- 解挂类型代码
    ,P1.UNLOST_DATE -- 解挂日期
    ,P1.UNCHAIN_BRANCH -- 解挂机构编号
    ,P1.UNCHAIN_AUTH_USER_ID -- 解挂授权柜员编号
    ,P1.UNLOST_USER_ID -- 解挂柜员编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.USER_ID -- 交易柜员编号
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,P1.DEAL_RESULT -- 处理结果描述
    ,decode(P1.PWD_FLAG,'Y','1','N','0',' ','-',P1.PWD_FLAG) -- 忘记密码标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_voucher_lost' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_voucher_lost p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
where  1 = 1 
   and p1.tran_date = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_vouch_loss_rgst_b truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_vouch_loss_rgst_b exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_vouch_loss_rgst_b_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_vouch_loss_rgst_b to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_vouch_loss_rgst_b_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_vouch_loss_rgst_b', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);