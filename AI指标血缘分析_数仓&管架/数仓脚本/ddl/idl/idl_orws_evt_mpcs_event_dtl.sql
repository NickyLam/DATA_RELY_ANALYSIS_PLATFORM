/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_evt_mpcs_event_dtl
CreateDate: 20221228
FileType:   DDL
Logs:
    Sundexin
*/

prompt creating table ${idl_schema}.orws_evt_mpcs_event_dtl
whenever sqlerror continue none;
drop table ${idl_schema}.orws_evt_mpcs_event_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_evt_mpcs_event_dtl(
   evt_id                      varchar2(120)     -- 事件编号       
  ,global_chn_seq_num          varchar2(60)     -- 全局渠道流水号    
  ,prev_global_chn_seq_num     varchar2(60)     -- 上一全局渠道流水号  
  ,prev_evt_id                 varchar2(60)     -- 上一事件编号     
  ,evt_typ_cd                  varchar2(4)      -- 事件类型代码     
  ,menuid                      varchar2(10)     -- 柜面菜单码      
  ,txn_num                     varchar2(60)     -- 交易码        
  ,txn_desc                    varchar2(100)    -- 交易描述       
  ,txn_dt                      date             -- 交易日期       
  ,txn_tm                      varchar2(30)     -- 交易时间       
  ,txn_ccy_cd                  varchar2(6)      -- 交易币种代码     
  ,txn_amt                     number(18,2)     -- 交易金额       
  ,acct_bal                    number(18,2)     -- 账户余额       
  ,cost_typ_cd                 varchar2(3)      -- 费用类型代码     
  ,fee_amt                     number(18,2)     -- 手续费金额      
  ,evt_status_cd               varchar2(20)     -- 事件状态代码     
  ,evt_reverse_typ_cd          varchar2(3)      -- 事件冲正类型代码   
  ,agt_id                      varchar2(60)     -- 协议编号       
  ,agt_id_name                 varchar2(200)    -- 协议全称       
  ,agt_blng_acct_num           varchar2(60)     -- 协议所属账号     
  ,prd_id                      varchar2(60)     -- 产品编号       
  ,pty_id                      varchar2(60)     -- 客户编号       
  ,txn_org_id                  varchar2(30)     -- 交易机构编号     
  ,txn_teller_id               varchar2(30)     -- 交易柜员编号     
  ,chk_teller_id               varchar2(30)     -- 复核柜员编号     
  ,auth_teller_id              varchar2(30)     -- 授权柜员编号     
  ,pty_mgr_id                  varchar2(30)     -- 客户经理编号     
  ,chn_typ_cd                  varchar2(4)      -- 渠道类型代码     
  ,chn_id                      varchar2(30)     -- 渠道编号       
  ,pay_chnl_typ_cd             varchar2(2)      -- 支付通道类型代码   
  ,cntrpty_id                  varchar2(60)     -- 交易对手编号     
  ,cntrpty_name                varchar2(255)    -- 交易对手名称     
  ,cntrpty_acct_openbk_num     varchar2(60)     -- 交易对手账户开户行号 
  ,cntrpty_acct_openbk_name    varchar2(255)    -- 交易对手账户开户行名称
  ,cntrpty_acct_num_id         varchar2(60)     -- 交易对手账号ID   
  ,cntrpty_acct_num            varchar2(60)     -- 交易对手账号     
  ,cntrpty_org_id              varchar2(30)     -- 交易对手机构编号   
  ,cntrpty_org_name            varchar2(100)    -- 交易对手机构名称   
  ,posting_dt                  date             -- 入账日期       
  ,posting_tm                  varchar2(30)     -- 入账时间       
  ,posting_org_id              varchar2(30)     -- 入账机构编号     
  ,posting_teller_id           varchar2(30)     -- 入账柜员编号     
  ,posting_ccy_cd              varchar2(3)      -- 入账币种代码     
  ,posting_amt                 number(18,2)     -- 入账金额       
  ,memo_cd                     varchar2(20)     -- 摘要码        
  ,memo                        varchar2(255)    -- 摘要         
  ,db_cr_dir_cd                varchar2(1)      -- 借贷标志       
  ,city_flg                    varchar2(1)      -- 同城标志       
  ,crossb_flg                  varchar2(1)      -- 跨行标志       
  ,ovsea_flg                   varchar2(1)      -- 境外标志       
  ,cash_tfr_flg                varchar2(1)      -- 现转标志       
  ,initor_typ_cd               varchar2(1)      -- 发起方类型代码    
  ,prim_vchr_type_cd           varchar2(60)     -- 主凭证种类代码    
  ,prim_vchr_num               varchar2(60)     -- 主凭证号码      
  ,scd_vchr_type_cd            varchar2(3)      -- 副凭证种类代码    
  ,scd_vchr_num                varchar2(30)     -- 副凭证号码      
  ,assoc_bcs_evt_id            varchar2(64)     -- 关联核心系统事件编号 
  ,reverse_evt_id              varchar2(60)     -- 冲正事件编号     
  ,flow_id                     varchar2(30)     -- 流程编号       
  ,assoc_coll_id               varchar2(30)     -- 关联抵质押品编号   
  ,nostro_flg                  varchar2(1)      -- 往账标志       
  ,bal_dir_cd                  varchar2(1)      -- 余额方向代码     
  ,bal_typ_cd                  varchar2(2)      -- 余额类型代码     
  ,txn_med_name                varchar2(100)    -- 交易介质名称     
  ,txn_med_id                  varchar2(30)     -- 交易介质编号     
  ,biz_typ_cd                  varchar2(4)      -- 业务类型代码     
  ,biz_cate_cd                 varchar2(5)      -- 业务种类代码     
  ,ghb_init_flg                varchar2(1)      -- 本行发起标志     
  ,old_vchr_num                varchar2(60)     -- 旧凭证号码      
  ,agt_blng_acct_num2          varchar2(60)     -- 协议所属账号2    
  ,agt_blng_acct_num3          varchar2(60)     -- 协议所属账号3    
  ,data_src_cd                 varchar2(4)      -- 数据来源代码     
  ,etl_dt                      date             -- 数据日期       
  ,job_cd                      varchar2(10)     -- 任务代码       
  ,etl_timestamp               timestamp(6)     -- 任务处理时间     

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.orws_evt_mpcs_event_dtl to ${icl_schema};
grant select on ${idl_schema}.orws_evt_mpcs_event_dtl to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_evt_mpcs_event_dtl is '中台事件交易明细';
comment on column idl.orws_evt_mpcs_event_dtl.evt_id is '事件编号';
comment on column idl.orws_evt_mpcs_event_dtl.global_chn_seq_num is '全局渠道流水号';
comment on column idl.orws_evt_mpcs_event_dtl.prev_global_chn_seq_num is '上一全局渠道流水号';
comment on column idl.orws_evt_mpcs_event_dtl.prev_evt_id is '上一事件编号';
comment on column idl.orws_evt_mpcs_event_dtl.evt_typ_cd is '事件类型代码';
comment on column idl.orws_evt_mpcs_event_dtl.menuid is '柜面菜单码';
comment on column idl.orws_evt_mpcs_event_dtl.txn_num is '交易码';
comment on column idl.orws_evt_mpcs_event_dtl.txn_desc is '交易描述';
comment on column idl.orws_evt_mpcs_event_dtl.txn_dt is '交易日期';
comment on column idl.orws_evt_mpcs_event_dtl.txn_tm is '交易时间';
comment on column idl.orws_evt_mpcs_event_dtl.txn_ccy_cd is '交易币种代码';
comment on column idl.orws_evt_mpcs_event_dtl.txn_amt is '交易金额';
comment on column idl.orws_evt_mpcs_event_dtl.acct_bal is '账户余额';
comment on column idl.orws_evt_mpcs_event_dtl.cost_typ_cd is '费用类型代码';
comment on column idl.orws_evt_mpcs_event_dtl.fee_amt is '手续费金额';
comment on column idl.orws_evt_mpcs_event_dtl.evt_status_cd is '事件状态代码';
comment on column idl.orws_evt_mpcs_event_dtl.evt_reverse_typ_cd is '事件冲正类型代码';
comment on column idl.orws_evt_mpcs_event_dtl.agt_id is '协议编号';
comment on column idl.orws_evt_mpcs_event_dtl.agt_id_name is '协议全称';
comment on column idl.orws_evt_mpcs_event_dtl.agt_blng_acct_num is '协议所属账号';
comment on column idl.orws_evt_mpcs_event_dtl.prd_id is '产品编号';
comment on column idl.orws_evt_mpcs_event_dtl.pty_id is '客户编号';
comment on column idl.orws_evt_mpcs_event_dtl.txn_org_id is '交易机构编号';
comment on column idl.orws_evt_mpcs_event_dtl.txn_teller_id is '交易柜员编号';
comment on column idl.orws_evt_mpcs_event_dtl.chk_teller_id is '复核柜员编号';
comment on column idl.orws_evt_mpcs_event_dtl.auth_teller_id is '授权柜员编号';
comment on column idl.orws_evt_mpcs_event_dtl.pty_mgr_id is '客户经理编号';
comment on column idl.orws_evt_mpcs_event_dtl.chn_typ_cd is '渠道类型代码';
comment on column idl.orws_evt_mpcs_event_dtl.chn_id is '渠道编号';
comment on column idl.orws_evt_mpcs_event_dtl.pay_chnl_typ_cd is '支付通道类型代码';
comment on column idl.orws_evt_mpcs_event_dtl.cntrpty_id is '交易对手编号';
comment on column idl.orws_evt_mpcs_event_dtl.cntrpty_name is '交易对手名称';
comment on column idl.orws_evt_mpcs_event_dtl.cntrpty_acct_openbk_num is '交易对手账户开户行号';
comment on column idl.orws_evt_mpcs_event_dtl.cntrpty_acct_openbk_name is '交易对手账户开户行名称';
comment on column idl.orws_evt_mpcs_event_dtl.cntrpty_acct_num_id is '交易对手账号id';
comment on column idl.orws_evt_mpcs_event_dtl.cntrpty_acct_num is '交易对手账号';
comment on column idl.orws_evt_mpcs_event_dtl.cntrpty_org_id is '交易对手机构编号';
comment on column idl.orws_evt_mpcs_event_dtl.cntrpty_org_name is '交易对手机构名称';
comment on column idl.orws_evt_mpcs_event_dtl.posting_dt is '入账日期';
comment on column idl.orws_evt_mpcs_event_dtl.posting_tm is '入账时间';
comment on column idl.orws_evt_mpcs_event_dtl.posting_org_id is '入账机构编号';
comment on column idl.orws_evt_mpcs_event_dtl.posting_teller_id is '入账柜员编号';
comment on column idl.orws_evt_mpcs_event_dtl.posting_ccy_cd is '入账币种代码';
comment on column idl.orws_evt_mpcs_event_dtl.posting_amt is '入账金额';
comment on column idl.orws_evt_mpcs_event_dtl.memo_cd is '摘要码';
comment on column idl.orws_evt_mpcs_event_dtl.memo is '摘要';
comment on column idl.orws_evt_mpcs_event_dtl.db_cr_dir_cd is '借贷标志';
comment on column idl.orws_evt_mpcs_event_dtl.city_flg is '同城标志';
comment on column idl.orws_evt_mpcs_event_dtl.crossb_flg is '跨行标志';
comment on column idl.orws_evt_mpcs_event_dtl.ovsea_flg is '境外标志';
comment on column idl.orws_evt_mpcs_event_dtl.cash_tfr_flg is '现转标志';
comment on column idl.orws_evt_mpcs_event_dtl.initor_typ_cd is '发起方类型代码';
comment on column idl.orws_evt_mpcs_event_dtl.prim_vchr_type_cd is '主凭证种类代码';
comment on column idl.orws_evt_mpcs_event_dtl.prim_vchr_num is '主凭证号码';
comment on column idl.orws_evt_mpcs_event_dtl.scd_vchr_type_cd is '副凭证种类代码';
comment on column idl.orws_evt_mpcs_event_dtl.scd_vchr_num is '副凭证号码';
comment on column idl.orws_evt_mpcs_event_dtl.assoc_bcs_evt_id is '关联核心系统事件编号';
comment on column idl.orws_evt_mpcs_event_dtl.reverse_evt_id is '冲正事件编号';
comment on column idl.orws_evt_mpcs_event_dtl.flow_id is '流程编号';
comment on column idl.orws_evt_mpcs_event_dtl.assoc_coll_id is '关联抵质押品编号';
comment on column idl.orws_evt_mpcs_event_dtl.nostro_flg is '往账标志';
comment on column idl.orws_evt_mpcs_event_dtl.bal_dir_cd is '余额方向代码';
comment on column idl.orws_evt_mpcs_event_dtl.bal_typ_cd is '余额类型代码';
comment on column idl.orws_evt_mpcs_event_dtl.txn_med_name is '交易介质名称';
comment on column idl.orws_evt_mpcs_event_dtl.txn_med_id is '交易介质编号';
comment on column idl.orws_evt_mpcs_event_dtl.biz_typ_cd is '业务类型代码';
comment on column idl.orws_evt_mpcs_event_dtl.biz_cate_cd is '业务种类代码';
comment on column idl.orws_evt_mpcs_event_dtl.ghb_init_flg is '本行发起标志';
comment on column idl.orws_evt_mpcs_event_dtl.old_vchr_num is '旧凭证号码';
comment on column idl.orws_evt_mpcs_event_dtl.agt_blng_acct_num2 is '协议所属账号2';
comment on column idl.orws_evt_mpcs_event_dtl.agt_blng_acct_num3 is '协议所属账号3';
comment on column idl.orws_evt_mpcs_event_dtl.data_src_cd is '数据来源代码';
comment on column idl.orws_evt_mpcs_event_dtl.etl_dt is '数据日期';
comment on column idl.orws_evt_mpcs_event_dtl.job_cd is '任务代码';
comment on column idl.orws_evt_mpcs_event_dtl.etl_timestamp is '任务处理时间';
